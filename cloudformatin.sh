#!/bin/bash

which aws

if [ $? -eq 1 ]; then
    echo "" 
    echo "Oops.Looks like we couldnot find aws cli installed"
    echo "" 
    exit
fi

if [[ $# -lt 3 ]];  then
    echo "" 
    echo "usage: $0 <region> <template> <stack-name>"
    echo ""
    echo "eg: ./cloudformatin.sh eu-west-2 ecs.yml ecs-cluster"
    exit
fi

region=$1 #eg. us-east-1
template=$2 #eg ecs-sg.yml
stack_name=$3

if [[  -z region || -z template || -z stack_name ]]; then
    echo "" 
    echo "parameters passed cannot be empty"
    exit
fi

aws cloudformation deploy \
--template-file ./infrastructure/$template  \
--region $region \
--stack-name $stack_name --capabilities CAPABILITY_NAMES_IAM