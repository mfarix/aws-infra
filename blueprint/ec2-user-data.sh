#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from EC2 created using Terraform</h1>" > /var/www/html/index.html
