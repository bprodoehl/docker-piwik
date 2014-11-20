#!/bin/bash

export HOME=/root

if [ ! -f /etc/ssl/server.pem ] || [ ! -f /etc/ssl/server.key ]; then
    cd /tmp
    openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
    openssl rsa -passin pass:x -in server.pass.key -out server.key
    rm server.pass.key
    openssl req -new -key server.key -out server.csr \
    -subj "/C=XX/ST=X/L=X/O=X/OU=X/CN=example.com"
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    cp server.key /etc/ssl/server.key
    cp server.crt /etc/ssl/server.pem
fi
