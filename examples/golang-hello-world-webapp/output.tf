################
# VPC
################
output "vpc_id" {
  description = "The VPC ID"
  value       = "${module.mydemo_vpc.vpc_id}"
}

output "vpc_cidr" {
  description = "CIDR  of the VPC"
  value       = "${module.mydemo_vpc.vpc_cidr}"
}

output "private_subnet_id" {
  description = "The subnet ID"
  value       = "${module.mydemo_vpc.private_subnet_id}"
}

output "public_subnet_id" {
  description = "The subnet ID"
  value       = "${module.mydemo_vpc.public_subnet_id}"
}

output "igw_id" {
  description = "The internet gateway ID"
  value       = "${module.mydemo_vpc.igw_id}"
}

output "elastic_public_ip" {
  description = "Public Elastic IP's"
  value       = "${module.mydemo_vpc.elastic_public_ip}"
}

output "ngw_id" {
  description = "The nat gateway ID"
  value       = "${module.mydemo_vpc.natgw_ip}"
}


################
# EC2
################

output "demo_sg_id" {
  description = "outputs webserver security group id"
  value       = "${module.mydemo_simple_mywebapp.webserver_sg_id}"
}

output "alb_id" {
  description = "application load balancer id"
  value       = "${module.mydemo_simple_mywebapp.alb_id}"
}

output "alb_dns_name" {
  description = "application load balancer dns name"
  value       = "${module.mydemo_simple_mywebapp.alb_dns_name}"
}

output "alb_dns_zone_id" {
  description = "application load balancer dns name"
  value       = "${module.mydemo_simple_mywebapp.alb_dns_zone_id}"
}
