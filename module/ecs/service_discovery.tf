resource "aws_service_discovery_private_dns_namespace" "db" {
  count = var.enable_db ? 1 : 0
  name        = "dev"
  description = "service discovery for apps in private subnet"
  vpc         =  var.vpc_id
}



resource "aws_service_discovery_service" "db" {
  count = var.enable_db ? 1 : 0
  name = "mysql"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.db[count.index].id

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