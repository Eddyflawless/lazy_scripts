#!/bin/bash
sudo su
yum update -y
yum install http -y
chkconfig http on
cd /var/www/html
aws s3 sync s3://mywebfiles /var/www/html
service httpd start