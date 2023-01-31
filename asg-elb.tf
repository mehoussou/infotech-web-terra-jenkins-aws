# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.22.0"
#     }
#   }
# }


# provider "aws" {
#   region = "us-east-2"
# }

# resource "aws_autoscaling_group" "infotech" {
#   name                 = "infotech-asg"
#   # vpc_zone_identifier = [aws_subnet.private.*.id]
#   vpc_zone_identifier         = "${aws_subnet.private.*.id}"

#   # launch_configuration = aws_launch_configuration.infotech.id
#   launch_configuration = "data.aws_instance.infotech.id"
#   min_size             = 1
#   max_size             = 5

#   tag {
#     key                 = "Name"
#     value               = "infotech-asg"
#     propagate_at_launch = true
#   }
# }

# # resource "aws_launch_configuration" "infotech" {
# #   name      = "infotech-lc"
# #   image_id  = "ami-0c55b159cbfafe1f0"
# #   instance_type = "t2.micro"

# # lifecycle {
# #     create_before_destroy = true
# #   }
# # }


# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "main"
#   }
# }

# resource "aws_alb" "infotech" {
#   name                = "infotech-alb"
#   internal            = false
#   security_groups   = [aws_security_group.infotech.id]
#   # subnets             = [aws_subnet.private.*.id]
#   subnets            = "${aws_subnet.private.*.id}"

#   tags = {
#     Name = "infotech-alb"
#   }
# }

# resource "aws_security_group" "infotech" {
#   name        = "infotech-sg"
#   description = "Allow HTTP traffic"

#   ingress {
#     from_port = 80
#     to_port   = 80

#  protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_subnet" "private" {
#   count = 2

#   cidr_block = "10.0.${count.index + 1}.0/24"
#   vpc_id     = aws_vpc.main.id
#   tags = {
#     Name = "private-${count.index + 1}"
#   }
# }

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "main"
#   }
# }
