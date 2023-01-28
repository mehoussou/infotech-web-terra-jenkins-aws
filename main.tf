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

resource "aws_vpc" "infotech-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "infotech-subnet-1" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.infotech-vpc.id
  default_route_table_id = aws_vpc.infotech-vpc.default_route_table_id
}

module "infotech-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.infotech-vpc.id
  my_ip = var.my_ip
  env_prefix = var.env_prefix
  avail_zone = var.avail_zone
  instance_type = var.instance_type
  # public_key_location = var.public_key_location
  image_name = var.image_name
  subnet_id = module.infotech-subnet-1.subnet.id
}

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
#   version = "2.6.0"

#   name = "infotect-vpc"
#   cidr_block = "10.0.0.0/16"
#   azs = data.aws_availability_zones.available.names
#   private_subnets = ["10.0.1.0/24","10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets = ["10.0.4.0/24","10.0.5.0/24", "10.0.6.0/24"]
#   enable_nat_gateway = true
#   single_nat_gateway = true
#   enable_dns_hostnames = true

# }