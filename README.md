# terraform-aws-devops-playground
A "Hello World" golang webapp deployed to AWS using terraform


## Status
![GitHub Repo size](https://img.shields.io/github/repo-size/bishy999/terraform-aws-devops-playground)
[![GitHub Tag](https://img.shields.io/github/tag/bishy999/terraform-aws-devops-playground.svg)](https://github.com/bishy999/terraform-aws-devops-playground/releases/latest)
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/bishy999/terraform-aws-devops-playground)](https://github.com/bishy999/terraform-aws-devops-playground)
[![GitHub Contributors](https://img.shields.io/github/contributors/bishy999/terraform-aws-devops-playground)](https://github.com/bishy999/terraform-aws-devops-playground)


## Pre-Requisites
   * [Terraform](https://www.terraform.io/) - Install
   * [AWS access](https://console.aws.amazon.com/) - With admin priviliges and ensure your [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) is working
   * [AWS Key Pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) - Create a key pair
   * Allow Terraform to use your `AWS` credentials in `~/.aws/credentials`
   * [Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html)  - Register a new domain
   * [Certificate Manager](https://aws.amazon.com/certificate-manager/) - Create a cert for your domain



## Version Requirements
| Name | Version |
|------|---------|
| terraform | ~> 0.12.24 |
| aws | ~> 2.61 |


### Overview of what this will build
![](images/DevopsPlayGround.png)


### How to create
```terraform

git clone https://github.com/bishy999/terraform-aws-devops-playground .
cd examples/golang-hello-world-webapp
Update specific values in main.tf
```

### Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc
```terraform
terraform init
```

### Preview of what it’s  going to create
```terraform
terraform plan
```


### Create stack
```terraform
terraform apply 

or

terraform apply -auto-approve
```

### Reads an output variable from a Terraform state file and prints the value
```terraform
terraform output 
```

### Delete stack
```terraform
terraform destroy
```
