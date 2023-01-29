terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}


resource "aws_vpc" "infotech-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module "networking" {
  source       = "./networking"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.infotec-vpc.id
  default_route_table_id = aws_vpc.infotech-vpc.default_route_table_id
  # vpc_cidr     = "10.0.0.0/16"
  # public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "webserver" {
  source        = "./webserver"
  vpc_id = aws_vpc.infotech-vpc.id
  my_ip= var.my_ip
  env_prefix = var.env_prefix
  avail_zone = var.avail_zone
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  image_name = var.image_name
  subnet_id = module.infotech-subnet.subnet.id
  # public_subnet = var.
}

