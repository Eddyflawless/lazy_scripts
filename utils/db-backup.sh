#!/bin/bash


$USER="root" #default
$PASSWORD=
verbose=0 #eg 1 - true | 0 - false
keep_day=30 #number of days to store the backup

# Notification email address 
recipient_email=g**@gmail.com

# Backup storage directory
backupfolder=/var/backups

$date_postfix=$(date +%d-%m-%Y_%H-%M-%S)
$file_formated_prefix=all-database-$date_postfix

sqlfile=$backupfolder/$file_formated_name.sql
zipfile=$backupfolder/$file_formated_name.zip 

#function definitions
usage(){
    echo ""
    echo  "Usage: $0 [-h host_ip_or_dns] [-u user] [-P port] [-p password] [-f path-to-perm] [-v verbose ]" 
    exit 0
}

install_utils(){
    sudo apt-get update 
    sudo apt-get install postfix mailutils zip
}

delete_old_backups(){
    find $backupfolder -type d -mtime +$keep_day -exec rm -rf {}
}

#compress backup
compress_file(){
    zip $zipfile $sqlfile 
    if [ $? == 0 ]; then
        echo 'The backup was successfully compressed' 
    else
        echo 'Error compressing backup' >& | send_mail "No backup was created"
        exit 
    fi 
}

send_mail(){

    subject = $1
    attach_file=-1
    while getopts ":a" options; do

        case $options in
        a)  
            if [ ! -f  $OPTARG]; then
                echo ""
                echo "Specified file $OPTARG does not exist"
                exit
            fi
            attach_file=$OPTARG
        ;;
        esac

    done
    shift $((OPTIND -1))

    if [[ -z "$subject" ]]; then
        subject="Something went wrong"
    fi

    mail_payload = $subject $recipient_email 

    if [[ $attach_file -ne -1 ]]; then
        $mail_payload="$mail_payload -A $attach_file"
    fi

    mailx -s $mail_payload
}

create_backup_all_databases(){

    echo ""
    echo "[$date_postfix] Creating initial database backup(s)"

    sudo mysqldump -u $USER -p$PASSWORD --all-databases > $sqlfile
    sleep 1
    if [ $? == 0 ]; then
        echo 'Sql dump created' 
    else
        echo 'mysqldump return non-zero code' | send_mail  'No backup was created!' 
        exit 
    fi
}

create_backup_single_database(){

    dbname=$1
     if [[ -z "$dbname" ]]; then
        echo "databasenmae cannot be an empty paramter"
        exit
    fi

    echo ""
    echo "[$date_postfix] Creating initial backup "

    sudo mysqldump -u $USER -p$PASSWORD --no-tablespaces $dbname > $sqlfile

    sleep 1
    if [ $? == 0 ]; then
        echo 'Sql dump created' 
    else
        echo 'mysqldump return non-zero code' | mailx -s 'No backup was created!' $recipient_email  
        exit 
    fi
}

post_up(){
    sudo rm -f $sqlfile
}


######## script execttion entry point #########

    #house warming
    install_utils

    #creare backup
    create_backup

    send_mail "Backup was successfully created"

    clean_up


######## end of script execttion entry point #########


