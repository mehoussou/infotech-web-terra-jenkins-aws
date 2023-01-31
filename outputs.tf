# output "elb-dns-name" {
#     value = aws_lb.infotech.dns_name
# }

# output "aws_ami_id" {
#     value = data.aws_ami.latest-amazon-linux-image.id
# }



output "elb" {
    value = aws_elb.custom-elb.dns_name
}
   

# output "nameservers" {
#   value       = aws_route53_zone.primary.name_servers
#   description = "List of nameservers to be used by the domain name provider e.g. GoDaddy."
# }