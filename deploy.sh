#!/usr/bin/env bash
cd /tmp
echo DOCKERUSER DOCKERPASSWORD DOCKERREGISTRY
echo Stopping docker-compose
docker-compose down || true
echo Starting docker-compose
docker-compose pull && docker-compose up -d