#!/bin/bash

sudo apt-get update
sudo apt-get install apache2
sudo apache2ctl configtest
sudo apt-get install php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring php-gettext
sudo apt-get install mysql-server

sudo phpenmod mcrypt
sudo phpenmod mbstring

sudo add-apt-repository -y ppa:ondrej/php
sudo ufw app list
sudo apt-get install curl
sudo ufw allow in "Apache Full"
sudo a2enmod rewrite
sudo systemctl restart apache2

sudo apt install software-properties-common
sudo apt update