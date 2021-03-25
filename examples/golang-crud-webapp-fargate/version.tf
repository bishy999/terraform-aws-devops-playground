terraform {
  required_version = ">= 0.14.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.28.0"
    }
  }
}