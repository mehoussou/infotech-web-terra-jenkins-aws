output "elb-dns-name" {
    value = aws_lb.application-lb.dns_name
}

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}