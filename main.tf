
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

# resource "aws_autoscaling_group" "example" {
#   name                      = "example"
#   max_size                  = 5
#   min_size                  = 2
#   desired_capacity          = 2
#   launch_configuration      = aws_launch_configuration.example.name
#   vpc_zone_identifier       = [aws_subnet.example.id]
#   health_check_type         = "ELB"
#   wait_for_capacity_timeout = "10m"
# }

# resource "aws_launch_configuration" "example" {
#   name                 = "example"
#   image_id             = "ami-0ff8a91507f77f867"
#   instance_type        = "t2.micro"
#   security_groups      = [aws_security_group.example.id]
#   user_data            = "${file("install_apache.sh")}"
# }

# resource "aws_security_group" "example" {
#   name        = "example"
#   description = "Example security group"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_subnet" "example" {
#   vpc_id                  = aws_vpc.example.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-2a"
# }

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_alb" "example" {
#     name = "example"
#     internal = false
#     security_groups = [aws_security_group.example.id]
#     subnets = [aws_subnet.example.id]
#     idle_timeout = 30
# }

# resource "aws_alb_listener" "example" {
#     load_balancer_arn = aws_alb.example.arn
#     port = "80"
#     protocol = "HTTP"
#     default_action {
#         target_group_arn = aws_alb_target_group.example.arn
#         type = "forward"
#     }
# }

# resource "aws_alb_target_group" "example" {
#   name = "example"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = aws_vpc.example.id
# }

# # resource "aws_elb_attachment" "example" {
# #     target_group_arn = aws_alb_target_group.example.arn
# #     # target_id = aws_autoscaling_group.example.id
# # }
