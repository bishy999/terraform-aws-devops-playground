################
# ECS
################
variable "ecs_cluster_name" {
  description = "The name of the ecs cluster"
}

variable "region" {
  description = "The region to have ecs resources"
}

variable "vpc_id" {
  description = "provide vpc_id"
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "domain_name" {
  description = "Domain name"
}

variable webapp_version {
  description = "version of the webapp to use"
}

variable webapp_port {
  description = "port to use in host/container"
}

variable protocol {
  default = "tcp"
}

variable "whitelist_ip_https" {
  description = "IP adresses to allow ssh access "
}

variable webapp_dockerhub_repo {
  description = "name of webapp repo"
}

variable webapp_cpu {
  description = "The number of cpu units used by the task"
}

variable webapp_memory {
  description = "The amount (in MiB) of memory used by the task"
}

variable db_version {
  description = "version of the fb to use"
  default = "1.0"
}

variable db_port {
  description = "port to use in host/container"
   default = 3306
}

variable db_cpu {
  description = "The number of cpu units used by the task"
  default = 256
}

variable db_memory {
  description = "The amount (in MiB) of memory used by the task"
  default = 512
}

variable enable_db {
  description = "The amount (in MiB) of memory used by the task"
  default = false
}

variable db_dockerhub_repo {
  description = "name of webapp repo"
  default = "test"
}


################
# Tags
################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}