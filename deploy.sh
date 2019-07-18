#!/usr/bin/env bash
cd /tmp
echo Stopping docker-compose
docker-compose down || true
echo Starting docker-compose
docker login DOCKERREGISTRY -u DOCKERUSER -p DOCKERPASSWORD
docker-compose pull && docker-compose up -d