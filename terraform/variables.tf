# current workspace name
locals {
  AWS_ENV = terraform.workspace == "default" ? "staging" : terraform.workspace
}

# AWS CLI credentials
# variable "ACCESS_KEY" {}
# variable "SECRET_KEY" {}
# variable "TOKEN" {}

# VPN Certs
variable "ACM_SERVER_CERT_ARN" {}
variable "ACM_CLIENT_CERT_ARN" {}

variable "REGION" {
  type = map(string)
  default = {
    production = "us-east-1"
    staging    = "us-east-1"
    dev        = "us-east-1"
  }
}

# Network

variable "VPC_BLOCK" {
  type = map(string)
  default = {
    production = "10.2.0.0/16"
    staging    = "10.1.0.0/16"
    dev        = "10.0.0.0/16"
  }
}

variable "SUBNET_1_BLOCK" {
  type = map(string)
  default = {
    production = "10.0.2.0/24"
    staging    = "10.0.1.0/24"
    dev        = "10.0.0.0/24"
  }
}

variable "SUBNET_2_BLOCK" {
  type = map(string)
  default = {
    production = "10.0.5.0/24"
    staging    = "10.0.4.0/24"
    dev        = "10.0.3.0/24"
  }
}

variable "VPC_CIDR" {
  type = map(string)
  default = {
    production = "10.300.0.0/22"
    staging    = "10.200.0.0/22"
    dev        = "10.100.0.0/22"
  }
}

# EC2

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "KEY_NAME" {
  default = "vockey"
}

# Amazon Linux 2023 AMI 64bit (x86)
variable "AMI" {
  type = map(string)
  default = {
    us-east-1 = "ami-0440d3b780d96b29d"
    us-west-1 = "ami-07619059e86eaaaa2"
  }
}
