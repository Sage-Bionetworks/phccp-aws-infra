#!/usr/bin/env bash
cd /tmp
echo Stopping docker-compose
docker-compose down || true
echo Starting docker-compose

DOCKERREGISTRY=$(aws ssm get-parameters --region us-east-1 --names DOCKER_REGISTRY --with-decryption --query Parameters[0].Value)
DOCKERUSER=$(aws ssm get-parameters --region us-east-1 --names DOCKER_USER --with-decryption --query Parameters[0].Value)
DOCKERPASSWORD=$(aws ssm get-parameters --region us-east-1 --names DOCKER_PASSWORD --with-decryption --query Parameters[0].Value)

export CERTS_DIR=certs
mkdir $CERTS_DIR
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Washington/L=Seattle/O=Sage Bionetworks/CN=www.sagebionetworks.org" -keyout $CERTS_DIR/server.key -out $CERTS_DIR/server.cert

cat $CERTS_DIR/server.key $CERTS_DIR/server.cert > $CERTS_DIR/mongodb.pem

docker login $DOCKERREGISTRY -u $DOCKERUSER -p $DOCKERPASSWORD
docker-compose pull && docker-compose up -d