################
# VPC
################

variable "region" {
  description = "Region to use e.g. eu-west-1"
}

variable "name" {
  description = "Name we will use when creating different resources in the VPC"
}

variable "cidr_block" {
  description = " The CIDR block for the VPC"
}

variable "cidr_block_destination" {
  description = "all addresses "
  default     = "0.0.0.0/0"
}


#################
# Private subnets
#################

variable "private_subnets" {
  description = "Private subnets"
  type        = map
}

variable "private_azs" {
  description = "Availability zones assigned to private subnets"
  type        = map
}


#################
# Public subnets
#################

variable "public_subnets" {
  description = "Public subnets"
  type        = map
}

variable "public_azs" {
  description = "Availability zones assigned to private subnets"
  type        = map

}

################
# Elastic IP
################

variable "eip_vpc" {
  description = "Boolean if the EIP is in a VPC or not"
  default     = true
}

################
# Tags
################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}





