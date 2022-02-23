#!/bin/bash

sudo apt-get update
sudo apt-get install apache2
sudo apache2ctl configtest
sudo apt-get install php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring php-gettext
sudo apt-get install mysql-server
# sudo mysql_secure_installation
# ALTER USER 'root'@localhost identified by mysql_native_password by '[your-new-password]'
# sudo apt-get install phpmyadmin
sudo phpenmod mcrypt
sudo phpenmod mbstring

sudo apt install phpmyadmin

#sudo nano /etc/apache2/conf-available/phpmyadmin.conf

#sudo apt install php7.1 php7.1-common php7.1-opcache php7.1-mcrypt php7.1-cli php7.1-gd php7.1-curl php7.1-mysql

sudo add-apt-repository -y ppa:ondrej/php
sudo ufw app list
sudo apt-get install curl
sudo ufw allow in "Apache Full"
sudo a2enmod rewrite
sudo systemctl restart apache2

sudo apt install software-properties-common
sudo apt update


# sudo add-apt-repository -y ppa:ondrej/php
# sudo apt update
# sudo apt install php5.6

# First disable PHP 7.2 module using command:
# sudo a2dismod php7.2

# Next, enable PHP 5.6 module
# sudo a2enmod php5.6

# Set PHP 5.6 as default version using command:
# sudo update-alternatives --set php /usr/bin/php5.6

# Alternatively, you can run the following command to set which system wide version of PHP you want to use by default.
# sudo update-alternatives --config php




# mysql -h mysql–instance1.123456789012.us-east-1.rds.amazonaws.com -P 3306 -u mymasteruser -p

