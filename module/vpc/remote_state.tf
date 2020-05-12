#terraform {
#backend s3 {
#encrypt=true
#bucket = "terrafrom-state-devopscork"
#region = "eu-west-1"
#dynamodb_table = "terraform-state"
#key="devopscork_vpc/terraform.tfstate"
#}
#}
