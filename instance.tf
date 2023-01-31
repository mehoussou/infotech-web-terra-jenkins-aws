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

# resource "aws_instance" "web-server" {
#     ami = data.aws_ami.latest-amazon-linux-image.id
#     instance_type = "t2.micro"
#     count = 2
#     key_name = "terraform_ec2_key"
#     # security_groups = ["${aws_security_group.web-server.name}"]
#     security_groups = ["${aws_security_group.infotech.name}"]
#     user_data              = filebase64("install_apache.sh")
#     # availability_zone = var.avail_zone
#     associate_public_ip_address = true

#     lifecycle {
#     create_before_destroy = true
#     }

#     tags = {
#         Name = "instance-${count.index}"
#     }
# }