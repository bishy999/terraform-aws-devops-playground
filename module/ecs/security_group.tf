resource "aws_security_group" "lb" {
  description = "Restrict access to your application"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "SG_ALB")
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "alb_https_in" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.whitelist_ip_https]
}


resource "aws_security_group_rule" "alb_out" {
  type              = "egress"
  security_group_id = aws_security_group.lb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "ecs_tasks" {
  description = "Allow inbound access to the ecs from the ALB only"
  vpc_id      = var.vpc_id


  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.lb.id]

  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      "Name" = format("%s%s", var.ecs_cluster_name, "SG_ECS")
    },
    var.tags,
  )
}