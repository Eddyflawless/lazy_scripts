#! /bin/bash
source constants.sh
echo "running $0 "

# Login as root user
# sudo su -
code_dir=
pem_file="./utils/pems/avis.pem"

loadEnv(){

    env_file=$1
    
    if [[ -z "$env_file"  ]]; then
        echo ""
        echo "No $env_file file found" 1>&2
        exit
    fi

    if [ -f $env_file ]
    then
        export $(cat "$env_file" | sed 's/#.*//g' | xargs)
    fi
}

printLine(){

    echo -e "----------------------------------------------------------------" . "\n"

}

createEnv(){
    touch .env
    echo "
    APP_NAME=AVIS
    APP_ENV=local
    APP_KEY=base64:5wFN8KWcyPO6xP8dPdHmXWDT9wOpbZ8yXsgDPFc53rY=
    APP_DEBUG=true
    APP_URL=http://localhost

    LOG_CHANNEL=stack

    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=anvil_smsx1
    DB_USERNAME=dustbin
    DB_PASSWORD=

    BROADCAST_DRIVER=pusher
    CACHE_DRIVER=file
    QUEUE_CONNECTION=sqs
    SESSION_DRIVER=file
    SESSION_LIFETIME=60

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379


    MAIL_MAILER=smtp
    MAIL_HOST=smtp.mailtrap.io
    MAIL_PORT=2525
    MAIL_USERNAME=21920cdcceea8a
    MAIL_PASSWORD=6bae2f28f0f5cc
    MAIL_ENCRYPTION=tls

    FIREBASE_CREDENTIALS=firebase_credentials.json

    AWS_ACCESS_KEY_ID=AKIARXVWQP5T3XWHRBOG
    AWS_SECRET_ACCESS_KEY=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
    AWS_DEFAULT_REGION=us-east-2
    AWS_BUCKET=v0rtex
    SQS_QUEUE=match-job-demo-queue
    SQS_PREFIX=https://sqs.us-east-2.amazonaws.com/119568105319

    PUSHER_APP_ID=902577
    PUSHER_APP_KEY=265755087f4b2bff28d5
    PUSHER_APP_SECRET=b8fb91d730ace1e0353b
    PUSHER_APP_CLUSTER=mt1

    MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

    JWT_SECRET=XuuPksRi4kXue99axjIv8iRLXY3MVyL1igOMT44EJBm81dqP7BeFx5cc32iy0HJl

    API_SERVICE_BASE_URL=localhost:8000
    AUTH_SERVICE_BASE_URL=localhost:8000
    AUTH_SERVICE_SECRET= 

    PRODUCT_VERSION= alpha_2.0
    PRODUCT_FEATURE_FLAG= TRUE


    SENTRY_LARAVEL_DSN=https://52ab05ae12664276beb7e5aee49d7f9e@o1054098.ingest.sentry.io/6153055

    SENTRY_TRACES_SAMPLE_RATE=1.0

    " > .env
}

install_composer(){
    echo "--------------------------------"
    echo "Installing composer...."
    echo "--------------------------------"
    apt-get install composer -y
    composer global require "laravel/installer"
    PATH=$PATH:$HOME/.config/composer/vendor/bin
    echo 'PATH=$PATH:$HOME/.config/composer/vendor/bin' >> $HOME/.bashrc

}

install_dependences(){
    apt-get update
    apt-get install apache2 -y
    apache2ctl configtest
    apt-get install php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring php-gettext -y
    apt-get install mysql-server -y
    phpenmod mcrypt
    phpenmod mbstring

}

install_mysql_server(){
    # Install MySQL
    apt install mysql-server
}

comfigure_mysql(){
    # Configure MySQL
    mysql -u root <<-EOF
    CREATE DATABASE databasename;
    CREATE USER 'example_laravel'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
    GRANT ALL PRIVILEGES ON databasename.* TO 'example_laravel'@'localhost';
EOF


}


laravel_cleanup_optimization_str(){

    echo "
        php artisan queue:restart
        php artisan view:clear 
        php artisan view:cache
    "
}

connect_to_server(){

    cleanup_optimization_str=laravel_cleanup_optimization_str  

    ssh ${NODE_SRV_USER}@${NODE_SRV_IP} <<EOF
    rm -rf /$code_dir
    git pull origin master 
    cd ~/$code_dir
    echo "optimizing laravel......."
    $cleanup_optimization_str
    php artisan serve

    exit

EOF


}

# bash main starts here

printLine


# if [[ -f $pem_file ]];then
#     echo ""
#     echo "pem file doesnot exists"
#     exit

# fi

createEnv

#loadEnv 

echo "attempting to ssh into: "${NODE_SRV_USER}@${NODE_SRV_IP}


# bash main ends here