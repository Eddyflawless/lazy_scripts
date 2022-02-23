#! bin/bash

# Script author: darkvadr
# Script date: 19-04-2021
# Script version: 1.0.0
#--------------------------------------------------
# List function:
# 1. bc_nginx_install: <description>
# 2. bc_mysql_server_install: <description>

bc_nginx_install() {

    #######Install nginx########
    echo ""
    echo "Installing Nginx..."
    echo ""
    sleep 1
        apt install nginx -y
        systemctl enable nginx && systemctl restart nginx
    echo ""
    sleep 1    
}

bc_mysql_server_install() {
    #######Install Mysql Server########
    echo ""
    echo "Installing Mysql Server..."
    echo ""
    sleep 1 
        apt install -y mysql-server
        systemctl enable mysql-server && restart mysql-server
    echo ""
    sleep 1
}

#call this function after installing mysql
bc_alter_mysql_root() {

    if [ $# -lt 2]; then
        echo ""
        echo "Not enough parameters"
        echo "Pass a parameter for the root's password"
        exit
    fi

    root_password=$1
    #######Create Database and User########
    echo ""
    echo "Modifying root user..."
    echo ""
    sleep 1
        mysql -uroot -p -e "ALTER USER 'root'@localhost identified by mysql_native_password by '$root_password' ;"
    echo ""
    sleep 1    

}

bc_create_new_user() {

    if [ $# -lt 2]; then
        echo ""
        echo "Not enough parameters"
        echo "First parameter must be the username, second the password and root's password"
        exit
    fi

    user_name=$1
    user_password=$2
    root_password=$3 
    ######Adding New  User########
    echo ""
    echo "Adding new user..."
    echo ""
    sleep 1
        mysql -uroot -p$root_password -e "CREATE USER '$user_name'@localhost identified by '$user_password'"
        mysql -uroot -p$root_password -e "GRANT ALL PRIVILEGES ON *.* TO '$user_name'@'localhost' WITH GRANT OPTION;"
    echo ""
    sleep 1    
}

bc_mysql_connect_host(){

    ######Adding New  User########
    echo ""
    echo "Setup mysql host pointing at rds instance..."
    echo "Argument 1 is rds instance url , argument 2 is user, argument 3 user_password"
    echo ""
    sleep 1
        #eg mysql -h mysql–instance1.123456789012.us-east-1.rds.amazonaws.com -P 3306 -u mymasteruser -p
        mysql -h $1 -P 3306 -u$2 -p$3
    echo ""
    sleep 1    
}


bc_nginx_conf_modify(){

    echo "Modfying Nginx Global Configurations...."
    echo ""
    sleep 1 
        sed -i "s///g" /etc/nginx/nginx.conf

    echo ""
    sleep 1

}

bc_house_warmer(){

    port=$1
    echo "...."
    echo ""
    sleep 1 
        apt install sudo ufw net-tools curl software-properties-common unzip vim -y
    echo ""
    sleep 1
}

bc_enable_ufw(){

    port=$1
    echo "...."
    echo ""
    sleep 1 
        ufw allow $port 
        ufw enable -y
        ufw reload
    echo ""
    sleep 1
}

bc_nginx_cong_create(){

cat > /etc/nginx/sites-enable/default<<EOF

error_log  logs/error.log;

upstream backend {
    server backend:3001;
};

server {
    listen *:80;
    access_log logs/a01.access.log combined;

    location /backend {
        rewrite; /backend/(.*) /$1 break;
        proxy_pass      http://backend;
    }; 
}
EOF

}

bc_setup_directory(){

    ####### #######
    echo ""
    echo "..."
    echo ""
    sleep 1
        mkdir -p /var/www/crm089
        chown -R www-data:www-data /var/www/crm089
        chmod -R 755 /var/www/crm089
    echo ""
    sleep 1    

}


bc_node_pm2() {

    #######Install node version manager and PM2 #######
    echo ""
    echo "Installing node version manager ..."
    echo ""
    sleep 1
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh  | bash 
        . ~/.nvm/nvm.sh
        source ~/.bashrc
        command -v nvm
        nvm install v10.11.0
    echo ""
    sleep 1

    #######PM2 #######
    echo ""
    echo "Installing PM@ ..."
    echo ""
    sleep 1
        npm install -g nodemon pm2
    echo ""
    sleep 1    

}

bc_check_root(){

    if(( $EUID != 0 )); then
        echo "Please run this script as root user. :("
        exit

    fi
}

bc_update(){
    echo ""
    echo "Intiating update and upgrad of packages ..."
    echo ""
    sleep 1
        apt update 
        apt upgrade -y
    echo ""
    sleep 1  

}

