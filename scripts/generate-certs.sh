#!/bin/bash

export HOME=/root

mkdir -p /etc/nginx-certs

if [ ! -f /etc/nginx-certs/server.pem ] || [ ! -f /etc/nginx-certs/server.key ]; then
    cd /tmp
    openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
    openssl rsa -passin pass:x -in server.pass.key -out server.key
    rm server.pass.key
    openssl req -new -key server.key -out server.csr \
    -subj "/C=XX/ST=X/L=X/O=X/OU=X/CN=example.com"
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    cp server.key /etc/nginx-certs/server.key
    cp server.crt /etc/nginx-certs/server.pem
fi
