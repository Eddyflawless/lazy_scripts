#! /bin/bash

source ./script/constants.sh
echo "running $0 "
echo "attempting to ssh into: "${NODE_SRV_USER}@${NODE_SRV_IP}

ssh ${NODE_SRV_USER}@${NODE_SRV_IP} <<EOF

    cd ~/artisan-matching-node-dev-test
    git pull origin master --allow-unrelated-histories
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh  | bash 
    . ~/.nvm/nvm.sh
    source ~/.bashrc
    command -v nvm
    nvm install v10.11.0
    npm install
    npm install -g nodemon pm2
    pm2 restart ecosystem.config.js

    exit


EOF

DSDS


