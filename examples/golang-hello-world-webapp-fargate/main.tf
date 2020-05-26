module "mydemo_vpc" {
  source = "../../module/vpc"

  name       = "DevOpsFargatePlayground"
  region     = "eu-west-1"
  cidr_block = "10.0.0.0/16"

  public_subnets = {
    "Public_A" = "10.0.1.0/24"
    "Public_B" = "10.0.2.0/24"
    "Public_C" = "10.0.3.0/24"
  }
  public_azs = {
    "Public_A" = "eu-west-1a"
    "Public_B" = "eu-west-1b"
    "Public_C" = "eu-west-1c"
  }

  private_subnets = {
    "Private_A" = "10.0.4.0/24"
    "Private_B" = "10.0.5.0/24"
    "Private_C" = "10.0.6.0/24"
  }
  private_azs = {
    "Private_A" = "eu-west-1a"
    "Private_B" = "eu-west-1b"
    "Private_C" = "eu-west-1c"
  }

  tags = {
    Owner       = "jdoe"
    Environment = "Dev"
    Team        = "ATeam"
  }
}


module "mydemo_ecs" {
  source = "../../module/ecs"

  vpc_id           = module.mydemo_vpc.vpc_id
  ecs_cluster_name = module.mydemo_vpc.name
  private_subnets  = module.mydemo_vpc.private_subnet_id
  public_subnets   = module.mydemo_vpc.public_subnet_id

  whitelist_ip_https = "0.0.0.0/0"
  domain_name        = "devopscork.com"

  webapp_version = "1.9-my-webapp"
  webapp_port    = 8080
  dockerhub_repo = "bishy999/golang"
  region         = "eu-west-1"
  cpu            = 256
  memory         = 512

  tags = {
    Owner       = "jdoe"
    Environment = "Dev"
    Team        = "ATeam"
  }
}


// Add alias record to route traffic to application load balancer
module "mydemo_route53" {
  source = "../../module/route53"

  domain_name     = "devopscork.com"
  alb_dns_name    = module.mydemo_ecs.alb_dns_name
  alb_dns_zone_id = module.mydemo_ecs.alb_dns_zone_id
}

