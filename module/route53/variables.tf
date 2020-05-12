################
# Route53
################
variable "domain_name" {
  description = "Domain name"
}


variable "alb_dns_name" {
  description = "Resource to map our dns to"
}


variable "alb_dns_zone_id" {
  description = "Zone id of the application load balancer"
}
