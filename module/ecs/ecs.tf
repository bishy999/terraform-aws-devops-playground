resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name

  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "ECS")
    },
    var.tags,
  )
}

resource "aws_ecs_task_definition" "app" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.webapp_cpu
  memory                   = var.webapp_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.ecs_cluster_name}-webapp-container"
    image     = "${var.webapp_dockerhub_repo}:${var.webapp_version}"
    # Set the secrets from AWS Secrets Manager
    environment =  [
            {"name": "MYSQL_HOST", "value": "mysql.dev"},
            {"name": "MYSQL_DB", "value": "demo"},
            {"name": "MYSQL_USERNAME", "value": "root"},
            {"name": "MYSQL_PASSWORD", "value": "Password1"},
            {"name": "MYSQL_PORT", "value": "3306"},
        ],
    essential = true
    portMappings = [{
      protocol      = var.protocol
      containerPort = var.webapp_port
      hostPort      = var.webapp_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region

      }
    }
    }]
  )
  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "ECS")
    },
    var.tags,
  )
}

resource "aws_ecs_task_definition" "db" {

  count = var.enable_db ? 1 : 0

  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_cpu
  memory                   = var.db_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.ecs_cluster_name}-db-container"
    image     = "${var.db_dockerhub_repo}:${var.db_version}"
    # TODO Set the secrets from AWS Secrets Manager
    environment =  [
            {"name": "hostname", "value": "mysql"},
            {"name": "MYSQL_ROOT_PASSWORD", "value": "Password1"},
        ],
    essential = true
    portMappings = [{
      protocol      = var.protocol
      containerPort = var.db_port
      hostPort      = var.db_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region

      }
    }
    }]
  )
  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "ECS")
    },
    var.tags,
  )
}

resource "aws_ecs_service" "frontend" {
  name                               = "${var.ecs_cluster_name}-frontend-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = 3
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.app_tasks.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "${var.ecs_cluster_name}-webapp-container"
    container_port   = var.webapp_port
  }

  depends_on = [
    aws_lb_listener.front_end,
  ]

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

//  Migrate to the new ARN and resource ID format for this work
/*  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "ECS")
    },
    var.tags,
  )*/
}

resource "aws_ecs_service" "backend" {
  count = var.enable_db ? 1 : 0
  name                               = "${var.ecs_cluster_name}-backend-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.db[count.index].arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.db_tasks.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

   service_registries {
      registry_arn = aws_service_discovery_service.db[count.index].arn
      container_name = "${var.ecs_cluster_name}-db-container"
  }


  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.ecs_cluster_name}-ecs"

  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "ECS")
    },
    var.tags,
  )
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.ecs_cluster_name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.ecs_cluster_name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}