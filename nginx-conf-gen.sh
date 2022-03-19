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
server {\n
\tserver_name $HOSTNAME;\n
\tlisten $HTTP_PORT;\n
\tlisten [::]:$HTTP_PORT;\n
\n
\tlocation / {\n
\t\treturn 301 https://\$host:$HTTPS_PORT\$request_uri;\n
\t}\n
}\n
\n
server {\n
\tserver_name $HOSTNAME;\n
\tlisten $HTTPS_PORT ssl http2;\n
\tlisten [::]:$HTTPS_PORT ssl http2;\n
\n
\tlocation / {\n
\t\tproxy_pass http://localhost:$DEST_PORT;\n
\t\tproxy_set_header Upgrade \$http_upgrade;\n
\t\tproxy_set_header Connection 'upgrade';\n
\t\tproxy_set_header Host \$http_host;\n
\t\tproxy_pass_request_headers on;\n
\t\tproxy_cache_bypass \$http_upgrade;\n
\t}\n
\n
\tssl_certificate /etc/ssl/certs/certbot-evryword.com.ng.pem;\n
\tssl_certificate_key /etc/ssl/private/certbot-evryword.com.ng.pem;\n
\tssl_dhparam /etc/ssl/certs/dhparam.pem;\n
}"

echo -e $conf > $nginxDest/$FILE_NAME
