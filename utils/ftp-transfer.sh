#!/bin/bash

pem_file='./pems/ahote3.pem'
user="ubuntu"
port=22
server_hostname='18.219.237.101' 
verbose=0 #eg 1 - true | 0 - false

usage(){
    echo ""
    echo  "Usage: $0 [-h host_ip_or_dns] [-u user] [-P port] [-p password] [-f path-to-perm] [-v verbose ]" 
    exit 0
}

# handle flags
while getopts ":h:u:P:p:f:v:b" options; do
    case $options in
        b )
            usage
        ;;
        h ) server_hostname=$OPTARG # process option hostname
        ;;
        u ) user=$OPTARG # process option user
        ;;
        P ) port=$OPTARG # process option port
        ;;
        p ) password=$OPTARG # process option password
        ;;
        f ) pem_file=$OPTARG # process option for pem file
        ;;
        v) verbose=$OPTARG # process option verbose flag
        ;;
        *) usage
        ;;
    esac    

done

shift $((OPTIND -1))

if [$vebose -eq 1]; then
    set -x
fi

# check for required flags


echo "User $user | port $port | server_hostname $server_hostname | verbose $verbose | permfile $pem_file"

exit

if [[ $# -lt 3 ]];  then
    echo "" 
    echo "usage: $0 <region> <template> <stack-name>"
    echo ""
    echo "eg: ./cloudformatin.sh eu-west-2 ecs.yml ecs-cluster"
    exit
fi

sourcedirfile=$1
sourcedir=$(basename $sourcedirfile | cut -d. -f1 ) #
distinationdir=$2 #eg  #eg /var/www/html/


if [ ! -f $pem_file ]; then

    echo ""
    echo "$pem_file doesnot exist. Make sure it exists in the current directory with the with permissions"
    echo "hint: sudo chmod 400 $pem_file"
    exit
fi

sftp ubuntu@$server_hostname -p$port <<EOT

cd $distinationdir
rm -fr $sourcedir
put -r $sourcedirfile
sudo  unzip $sourcedirfile
sudo rm -f $sourcedirfile
sudo chown -R $user:www-data $sourcedir
bye

EOT


#function definitions

cleanup(){


    return 1

}

echo "all done"