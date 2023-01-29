
resource "aws_subnet" "infotech-subnet-1" {
 
  vpc_id                  =  var.vpc_id
  cidr_block              =  var.subnet_cidr_block
  availability_zone       =  var.avail_zone

  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "infotech-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
 
resource "aws_default_route_table" "main_rtb" {
  default_route_table_id = var.default_route_table_id

  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infotech-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

# resource "aws_route" "default_public_route" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }

# resource "aws_security_group" "web_sg" {
#   name        = "web_sg"
#   description = "Allow all inbound HTTP traffic"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
