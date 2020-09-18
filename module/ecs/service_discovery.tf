resource "aws_service_discovery_private_dns_namespace" "db" {
  name        = "dev"
  description = "service discovery for apps in private subnet"
  vpc         =  var.vpc_id
}



resource "aws_service_discovery_service" "db" {
  name = "mysql"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.db.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}