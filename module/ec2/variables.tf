#################
# Security Group
#################
variable "vpc_id" {
  description = "provide vpc_id"
}
variable "https_port" {
  default = "443"
}

variable "ssh_port" {
  default = "22"
}

variable "protocol" {
  default = "tcp"
}

variable "whitelist_ip_ssh" {
  description = "IP adresses to allow ssh access "
}

variable "whitelist_ip_https" {
  description = "IP adresses to allow ssh access "
}

variable "whitelist_ip_vpc" {
  description = "CIDR of vpc"
}


################
# Tags
################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}


################
# ASG
################
variable "name" {
  description = "Name we will use when creating different resources"
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

################
# Launch Config
################

variable "instance_type" {
  description = "instance type ..."
}

variable "ami" {
  description = "amazon machine image"
}

variable "key_name" {
  description = "ec2 key to access instance"
}

variable "domain_name" {
  description = "Domain name"
}

variable webapp_version {
  description = "version of the webapp to use"
}

variable dockerhub_repo {
  description = "name of repo"
}


