#!/bin/bash


# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "WELCOME TO INFOTECH from $(hostname -f)" > /var/www/html/index.html

sudo su
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><h1> Welcome to our INFOTECH interview. Happy learning project from $(hostname -f)...</p> </h1>" > /var/www/html/index.html

