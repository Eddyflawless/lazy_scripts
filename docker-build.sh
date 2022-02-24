#!/bin/sh

declare -a dockerFiles
prefix="zeta_microservices"
services=("client-service" "notification-service" )
service_ports=("82:3000" "81:30001")
ecr_repository=119568105319.dkr.ecr.eu-west-2.amazonaws.com
region="eu-west-2"

remove_dangling_images(){
    docker images -f "dangling=true" -q
}

serve_application_detached(){

    count=0
    for svc  in "${services[@]}"; do

        svc_port=${service_ports[$count]}
        _container=$(construct_container_name $svc)
        docker run -d -p 82:3000 $_container

    done
    
}

stop_all(){

    for svc  in "${services[@]}"; do

        _container=$(construct_container_name $svc)
        docker stop $(docker ps | grep "$_container" | awk '{ print $1}')

    done

    clean_up
}

construct_container_name(){

    service_name=$1
    echo $prefix"_"$svc

}

stop_rebuild(){

    stop_all
    run_build
}

push_images_to_ecr(){

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

push_images(){

    #tag image
    push_images_to_ecr $1

}

clean_up(){
    unset dockerFiles
    unset prefix
    unset services
}


#${sounds[@]} returns all values
#${!sounds[@]} returns all keys

run_multi(){

    for svc  in "${services[@]}"; do
        _container=$(construct_container_name $svc)
        run_single_build $_container $svc
    done

}

run_single(){
    docker run -d -p 82:3000 $1 $2
}

build_multi(){

    for svc  in "${services[@]}"; do
        _container=$(construct_container_name $svc)
        dir="$svc/."
        build_single $_container $dir

    done

}

build_single(){

    container_name=$1
    dir=$2
    docker build -t $container_name $dir

}


#function definitions
usage(){
    echo ""
    echo  "Helper bible" 
    echo  ""
    exit 0
}

if [[ "$#" -eq 0  ]]; then

    usage 

fi