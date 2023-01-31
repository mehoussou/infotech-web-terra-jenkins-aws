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


# resource "aws_vpc" "example" {
#     cidr_block = "10.0.0.0/16"
# }


# resource "aws_subnet" "example_a" {

#     vpc_id = aws_vpc.example.id
#     cidr_block = "10.0.0.0/24"
#     availability_zone = "us-east-2a"
# }

# resource "aws_subnet" "example_b" {

#     vpc_id = aws_vpc.example.id
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "us-east-2b"
# }

# # resource "aws_internet_gateway" "gw" {
# #     vpc_id = aws_vpc.exemple.id

# #     tags = {
# #         Name = "main"
# #   }
# # }

# resource "aws_route_table" "exemple-route-table" {
#     vpc_id = aws_vpc.exemple.id
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.exemple.id
#     }
#     tags = {
#         Name = "main"
#     }
# }













# resource "aws_launch_configuration" "example" {

#     image_id = "ami-0c3e948c202466e2b"
#     instance_type = "t2.micro"
# }

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

# #     # tags = {
# #     #     Name = "instance-${count.index}"
# #     # }
# # }


# resource "aws_autoscaling_group" "example" {

#     launch_configuration = aws_launch_configuration.example.name
#     # launch_configuration = aws_instance.example.name
#     # name = "example"
#     min_size = 1
#     max_size = 5
#     desired_capacity = 2
#     vpc_zone_identifier = [aws_subnet.example_a.id, aws_subnet.example_b.id]
# }

# resource "aws_alb" "example" {

#     name = "example-alb"
#     internal = false
#     security_groups = [aws_security_group.example.id]
#     subnets = [aws_subnet.example_a.id, aws_subnet.example_b.id]
# }

# resource "aws_alb_target_group" "example" {

#     name = "example-target-group"
#     port = 80
#     protocol = "HTTP"
#     vpc_id = aws_vpc.example.id

# health_check {
#     path = "/health"
#     interval = 30
#     timeout = 5
#     healthy_threshold = 2
#     unhealthy_threshold = 2
# }

# }

# resource "aws_alb_listener" "example" {

#     load_balancer_arn = aws_alb.example.arn
#     port = "80"
#     protocol = "HTTP"

# default_action {

#     type = "forward"
#     target_group_arn = aws_alb_target_group.example.arn
# }
# }

# resource "aws_autoscaling_attachment" "example" {

#     autoscaling_group_name = aws_autoscaling_group.example.name
#     alb_target_group_arn = aws_alb_target_group.example.arn
# }

# resource "aws_security_group" "example" {

#     name = "example"
#     description = "Example security group"
#     vpc_id = aws_vpc.example.id

# ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
# }
# }