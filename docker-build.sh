#!/bin/bash

run_build(){

    docker build -t zeta-microservices_client-service  ./client-service
    docker build -t zeta-microservices_notification-service ./notification-service

}


serve_application_detached(){

    docker run -d -p 82:3000 zeta-microservices_client-service
    docker run -d -p 3001:3001 zeta-microservices_notification-service
}

stop_all(){

    docker stop $(docker ps | grep "zeta-microservices_client-service" | awk '{ print $1}')
    docker stop $(docker ps | grep "zeta-microservices_notification-service" | awk '{ print $1}')
}

stop_rebuild(){

    stop_all
    run_build
}

push_images_to_ecr(){

    ecr_repository=119568105319.dkr.ecr.eu-west-2.amazonaws.com
    image_to_push=$1

    if [ $# -lt 1 ]; then
        echo "Provide repository name to push images to"
        echo "usage: push_images_to_ecr <image-name>"
        echo "eg: push_images_to_ecr v1testapi"
        return 1
    fi

    r1=$(aws ecr get-login-password --region eu-west-2)

    sleep 1

    if [[ $? -ne 0 ]]; then
        echo "--------------- ALERT -------------------"
        echo -e "Somthing wrong happened" >&2
        return
    fi
       
    echo $r1 | docker login --username AWS --password-stdin $ecr_repository

    docker tag $image_to_push:latest $ecr_repository/$image_to_push:latest

    docker push $ecr_repository/$image_to_push:latest

    echo "push image $image_to_push:latest  to  $ecr_repository/$image_to_push:latest"

    
}





# zeta-microservices_notification-service

docker build -t zeta-microservices_client-service .

docker build -t zeta-microservices_notification-service  .


docker tag zeta-microservices_client-service:latest 119568105319.dkr.ecr.eu-west-2.amazonaws.com/v1-client-api:latest



docker build -t zeta-microservices_notification-service  .

docker tag zeta-microservices_notification-service  119568105319.dkr.ecr.eu-west-2.amazonaws.com/v1-notification-api:latest

docker push 119568105319.dkr.ecr.eu-west-2.amazonaws.com/v1-notification-api:latest

# docker tag zeta-microservices_notification-service:latest 119568105319.dkr.ecr.eu-west-2.amazonaws.com/v1-notification-api:latest


 docker images -f "dangling=true" -q