resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# resource "aws_key_pair" "ssh-key" {
#   key_name = "myapp-key-pair"
#   public_key = file(var.public_key_location)
# }

resource "aws_instance" "infotech-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
#   key_name = aws_key_pair.ssh-key.key_name

  user_data = file("install_apache.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}

# resource "aws_subnet" "private-us-east-2a" {
#     vpc_id = aws_vpc.infotech-vpc.id
#     cidr_block = var.cidr_block.id
#     availability_zone = us-est-2a

#     tags = {
#         Name = "private-us-east-2a"
#     }
# }

# resource "aws_subnet" "public-us-east-2a" {
#     vpc_id = aws_vpc.infotech-vpc.id
#     cidr_block = var.cidr_block.id
#     availability_zone = us-est-2a
#     map_public_ip_on_launch = true

#     tags = {
#         Name = "public-us-east-2a"
#     }
# }

# resource "aws_autoscaling_group" "infotech-web" {
#   name_prefix           = "asg-infotech-web"
#   # vpc_zone_identifier = tolist(var.public_subnet)
#   vpc_id = module.vpc.vpc_id
#   min_size            = 1
#   max_size            = 2
#   desired_capacity    = 2
# }