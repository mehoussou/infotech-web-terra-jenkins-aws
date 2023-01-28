terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}


# module "networking" {
#   source       = "./networking"
#   vpc_cidr     = "10.0.0.0/16"
#   public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# module "compute" {
#   source        = "./compute"
#   web_sg        = module.networking.web_sg
#   public_subnet = module.networking.public_subnet
# }

resource "aws_vpc" "infotech-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "infotech-subnet-1" {
  vpc_id = aws_vpc.infotech-vpc.id
  cidr_block = var.subnet_cidr_block
}
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

resource "aws_internet_gateway" "infotech-igw" {
  vpc_id = aws_vpc.infotech-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.infotech-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infotech-igw.id
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.infotech-vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["var.my_ip"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-default-sg  "
  }
}



