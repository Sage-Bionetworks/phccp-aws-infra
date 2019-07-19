#!/usr/bin/env bash
cd /tmp
echo Stopping docker-compose
docker-compose down || true
echo Starting docker-compose

DOCKERREGISTRY=$(aws ssm get-parameters --region us-east-1 --names DOCKER_REGISTRY --with-decryption --query Parameters[0].Value)
DOCKERUSER=$(aws ssm get-parameters --region us-east-1 --names DOCKER_USER --with-decryption --query Parameters[0].Value)
DOCKERPASSWORD=$(aws ssm get-parameters --region us-east-1 --names DOCKER_PASSWORD --with-decryption --query Parameters[0].Value)

docker login $DOCKERREGISTRY -u $DOCKERUSER -p $DOCKERPASSWORD
docker-compose pull && docker-compose up -d