#! /bin/bash

env_file=$(pwd)"/.env"

#load .env file
loadEnv(){
    _env_file=$1
    
    if [[ ! -f "$_env_file"  && ! -z "$_env_file"  ]]; then
        echo ""
        echo "No .env file found"
        exit
    fi

    if [ -f .env ]
    then
        export $(cat "$env_file" | sed 's/#.*//g' | xargs)
    else
        echo "No $env_file file found" 1>&2
        return 1
    fi
}
