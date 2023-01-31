# # data "aws_vpc" "default" {
# #   default = true
# # }

# # data "aws_subnet_ids" "subnet" {
# #   vpc_id = data.aws_vpc.default.id
# # }

# variable "vpc_cidr_block" {
#   description = "vpc cidr block"
# }

# variable "vpc_name" {
#   description = "vpc name"
# }

# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
# }

# variable "subnet_name" {
#   description = "subnet name"
# }


# resource "aws_vpc" "infotech-vpc" {
#   cidr_block = var.vpc_cidr_block
#   tags = {
#     Name = var.vpc_name
#   }
# }

# resource "aws_subnet" "inf-subnet-1"{
#   vpc_id = aws_vpc.infotech-vpc.id
#   cidr_block = var.subnet_cidr_block
#   availability_zone = "us-east-2a"
#   tags = {
#     Name = var.subnet_name
#   }
# }


# output "inf-vpc-id" {
#   value = aws_vpc.infotech-vpc.id
# }


# output "inf-subnet-id" {
#   value = aws_subnet.inf-subnet-1.id
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main-rt"
  }
}

resource "aws_route_table_association" "subnet_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.main.id
}

resource "aws_launch_configuration" "web_app_lc" {
  image_id      = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

# data "aws_ami" "latest-amazon-linux-image" {
#     most_recent = true
#     owners = ["amazon"]

#     filter {
#         name   = "name"
#         values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#     }

#     filter {
#         name   = "virtualization-type"
#         values = ["hvm"]
#     }
# }

# # resource "aws_launch_configuration" "example" {
# #     # resource "aws_instance" "example" {

# #     ami = data.aws_ami.latest-amazon-linux-image.id
# #     instance_type = "t2.micro"
# #     # count = 2
# #     key_name = "terraform_ec2_key"
# #     user_data              = filebase64("install_apache.sh")
# #     associate_public_ip_address = true

# #     lifecycle {
# #     create_before_destroy = true
# #     }




















resource "aws_autoscaling_group" "web_app_asg" {
  vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  launch_configuration = aws_launch_configuration.web_app_lc.name
  min_size             = 1
  max_size             = 3

  tags = [
    {
      key                 = "Name"
      value               = "web-app-asg"
      propagate_at_launch = true
    },
  ]
}

resource "aws_elb" "web_app_elb" {
  name               = "web-app-elb"
  security_groups    = [aws_security_group.web_app_elb.id]

    internal = false
    subnets = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_elb_target_group" "web_app_elb" {

    name = "web_app-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.web_app.id

health_check {
    path = "/health"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
}

}

resource "aws_elb_listener" "web_app" {

    load_balancer_arn = aws_elb.web_app_elb.arn
    port = "80"
    protocol = "HTTP"

default_action {

    type = "forward"
    target_group_arn = aws_elb_target_group.web_app.arn
}
}

resource "aws_autoscaling_attachment" "web_app" {

    autoscaling_group_name = aws_autoscaling_group.web_app.name
    alb_target_group_arn = aws_alb_target_group.web_app.arn
}

resource "aws_security_group" "example" {

    name = "web_app"
    description = "Example security group"
    vpc_id = aws_vpc.web_app.id

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
