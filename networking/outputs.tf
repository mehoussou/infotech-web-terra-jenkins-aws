# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}

# output "ec2_public_ip" {
#   value = module.public
# }
