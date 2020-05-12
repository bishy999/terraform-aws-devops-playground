output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR  of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "name" {
  description = "name provided for resources"
  value       = var.name
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = [for r in aws_subnet.private : r.id]
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = [for r in aws_subnet.public : r.id]
}

output "igw_id" {
  description = "ID of the igw"
  value       = aws_internet_gateway.igw.id
}

output "elastic_public_ip" {
  description = "Public Elastic IP's"
  value       = [for r in aws_eip.eip : r.public_ip]
}

output "natgw_ip" {
  description = "ID of the nat gateway"
  value       = [for r in aws_nat_gateway.nat-gw : r.id]
}
