#!/usr/bin/env bash
cd /tmp
echo Stopping docker-compose
docker-compose down || true
echo Starting docker-compose

DOCKERREGISTRY=$(aws ssm get-parameters --region us-east-1 --names DOCKER_REGISTRY --with-decryption --query Parameters[0].Value | sed 's\"\\g')
DOCKERUSER=$(aws ssm get-parameters --region us-east-1 --names DOCKER_USER --with-decryption --query Parameters[0].Value | sed 's\"\\g')
DOCKERPASSWORD=$(aws ssm get-parameters --region us-east-1 --names DOCKER_PASSWORD --with-decryption --query Parameters[0].Value | sed 's\"\\g')

# export OATH_GOOGLE_ID=$(aws ssm get-parameters --region us-east-1 --names OATH_GOOGLE_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export OAUTH_GOOGLE_SECRET=$(aws ssm get-parameters --region us-east-1 --names OAUTH_GOOGLE_SECRET --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export SAML_GOOGLE_ENTRY_POINT=$(aws ssm get-parameters --region us-east-1 --names SAML_GOOGLE_ENTRY_POINT --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export SAML_GOOGLE_ISSUER=$(aws ssm get-parameters --region us-east-1 --names SAML_GOOGLE_ISSUER --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export AZUREAD_OPENIDCONNECT_IDENTITY_METADATA=$(aws ssm get-parameters --region us-east-1 --names AZUREAD_OPENIDCONNECT_IDENTITY_METADATA --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export AZUREAD_OPENIDCONNECT_CLIENT_ID=$(aws ssm get-parameters --region us-east-1 --names AZUREAD_OPENIDCONNECT_CLIENT_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export ROCHE_AZURE_AD_IDENTITY_METADATA=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_IDENTITY_METADATA --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export ROCHE_AZURE_AD_CLIENT_ID=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_CLIENT_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export ROCHE_AZURE_AD_CLIENT_SECRET=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_CLIENT_SECRET --with-decryption --query Parameters[0].Value | sed 's\"\\g')
export NEO4J_USERNAME=neo4j
export NEO4J_PASSWORD=password

export CERTS_DIR=certs
mkdir $CERTS_DIR
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Washington/L=Seattle/O=Sage Bionetworks/CN=www.sagebionetworks.org" -keyout $CERTS_DIR/server.key -out $CERTS_DIR/server.cert

cat $CERTS_DIR/server.key $CERTS_DIR/server.cert > $CERTS_DIR/mongodb.pem

docker login $DOCKERREGISTRY -u $DOCKERUSER -p $DOCKERPASSWORD
docker-compose pull && docker-compose up -d