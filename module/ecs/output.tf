output "alb_id" {
  description = "application load balancer id"
  value       = aws_lb.alb.id
}

output "alb_dns_name" {
  description = "application load balancer dns name"
  value       = aws_lb.alb.dns_name
}

output "alb_dns_zone_id" {
  description = "application load balancer dns name"
  value       = aws_lb.alb.zone_id
}