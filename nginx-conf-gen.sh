#!/bin/bash

HTTP_PORT=80;
HTTPS_PORT=443;

if [ "$1" == '' ]
then
    echo 'Hostname is missing';
    exit 127;
fi

HOSTNAME=$1;

echo "$2" == '--purpose=backend';
# exit;

if [ "$2" == '--purpose=backend' ]
then
    HTTP_PORT=$(($3 + 15));
    HTTPS_PORT=$(($3 + 16));
else
    HTTP_PORT=80;
    HTTPS_PORT=443;
fi

if [ "$3" == '' ]
then
    echo 'Destination Port is missing';
    exit 127;
fi

DEST_PORT=$3;

if [ "$4" == '' ]
then
    echo 'Nginx configuration Destination file name not found';
    exit 127;
fi

FILE_NAME=$4;

nginxDest='/etc/nginx/conf.d';

if [ "$5" == '' ]
then
    echo 'Nginx Configuration Destination Path not specified using '$nginxDest;
else
    nginxDest=$5;
fi

conf="
server {
    server_name $HOSTNAME;
    listen $HTTP_PORT;
    listen [::]:$HTTP_PORT;

    location / {
        return 301 https://\$host:$HTTPS_PORT\$request_uri;
    }
}

server {
    server_name $HOSTNAME;
    listen $HTTPS_PORT ssl http2;
    listen [::]:$HTTPS_PORT ssl http2;

    location / {
        proxy_pass http://localhost:$DEST_PORT;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$http_host;
        proxy_pass_request_headers on;
        proxy_cache_bypass \$http_upgrade;
    }

    ssl_certificate /etc/ssl/certs/certbot-evryword.com.ng.pem;
    ssl_certificate_key /etc/ssl/private/certbot-evryword.com.ng.pem;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
}"

echo $conf > $nginxDest/$FILE_NAME
