#!/bin/bash

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "WELCOME TO INFOTECH from $(hostname -f)" > /var/www/html/index.html

sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -d -p 8080:80 nginx


