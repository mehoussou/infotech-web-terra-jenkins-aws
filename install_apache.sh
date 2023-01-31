# #!/bin/bash

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "WELCOME TO INFOTECH from $(hostname -f)" > /var/www/html/index.html

 #!/bin/bash
 yum update -y && sudo yum install -y docker
 systemctl start docker
 usermod -aG docker ec2-user
 docker run -d -p 8080:80 nginx
