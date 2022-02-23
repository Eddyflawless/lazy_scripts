#!/bin/bash

sudo apt-get update

sudo apt-get install apache2

sudo apache2ctl configtest

sudo apt-get install php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring php-gettext

sudo apt-get install mysql-server

sudo /etc/init.d/mysql start

sudo mysql_secure_installation

# ALTER USER 'root'@localhost identified by mysql_native_password by '[your-new-password]'

# CREATE USER 'darkvar_01'@localhost identified by '[your-new-password]'

# GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;


# FLUSH PRIVILEGES;

sudo phpenmod mcrypt

sudo phpenmod mbstring

sudo apt-get install phpmyadmin


sudo add-apt-repository -y ppa:ondrej/php

sudo ufw app list

sudo apt-get install curl

sudo ufw allow in "Apache Full"

sudo a2enmod rewrite

sudo systemctl restart apache2

sudo apt install software-properties-common

sudo apt update

echo "http://your_domain_or_IP/phpmyadmin"


# secure phpmyadmin

sudo nano /etc/apache2/conf-available/phpmyadmin.conf

sudo systemctl restart apache2





