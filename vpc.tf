terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

variable "instance_type" {}
variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availability_zones" "azs" {}


module "infotech-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "infotech-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs =  data.aws_availability_zones.azs.names
  
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/infotech-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/infotech-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/infotech-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}