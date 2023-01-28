# --- compute/main.tf ---

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resource "aws_launch_template" "web" {
#   name_prefix            = "web"
#   image_id               = data.aws_ami.linux.id
#   instance_type          = var.web_instance_type
#   vpc_security_group_ids = [var.web_sg]
#   user_data              = filebase64("install_apache.sh")

#   tags = {
#     Name = "web"
#   }
# }
resource "aws_instance" "infotech-web" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  subnet_id = aws_subnet.infotech-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = "myapp-key-pair"
  
  user_data              = filebase64("install_apache.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}

resource "aws_autoscaling_group" "infotech-web" {
  name                = "infotech-web"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 1
  max_size            = 2
  desired_capacity    = 3

#   tags = {

#   }

#   launch_template {
#     id      = aws_launch_template.web.id
#     version = "$Latest"
#   }
# }
