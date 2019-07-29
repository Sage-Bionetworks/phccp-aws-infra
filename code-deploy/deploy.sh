#!/usr/bin/env bash
cd /tmp

DOCKERREGISTRY=$(aws ssm get-parameters --region us-east-1 --names DOCKER_REGISTRY --with-decryption --query Parameters[0].Value | sed 's\"\\g')
DOCKERUSER=$(aws ssm get-parameters --region us-east-1 --names DOCKER_USER --with-decryption --query Parameters[0].Value | sed 's\"\\g')
DOCKERPASSWORD=$(aws ssm get-parameters --region us-east-1 --names DOCKER_PASSWORD --with-decryption --query Parameters[0].Value | sed 's\"\\g')

export CERTS_DIR=certs
mkdir $CERTS_DIR
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Washington/L=Seattle/O=Sage Bionetworks/CN=www.sagebionetworks.org" -keyout $CERTS_DIR/server.key -out $CERTS_DIR/server.cert

cat $CERTS_DIR/server.key $CERTS_DIR/server.cert > $CERTS_DIR/mongodb.pem

# MONGODB
export MONGO_PORT=27017
export MONGO_INITDB_ROOT_USERNAME=admin
export MONGO_INITDB_ROOT_PASSWORD=password
## Configuring for the portal
export MONGO_INITDB_DATABASE=phccp
export MONGO_USERNAME=app
export MONGO_PASSWORD=app123

# PORTAL
export NODE_ENV=production
export CLIENT_PORT=
export PORT=443
export DOMAIN=https://localhost

## Session secret
export SESSION_SECRET=phccp-secret

## Configuring SSL
export SSL_KEY=`cat ./certs/server.key`
export SSL_CERT=`cat ./certs/server.cert`

## Configuring connection with MongoDB
export MONGODB_PROTOCOL=mongodb
export MONGODB_IP=localhost
export MONGODB_PORT=${MONGO_PORT}
export MONGODB_PATH=/${MONGO_INITDB_DATABASE}
export MONGODB_USER=${MONGO_USERNAME}
export MONGODB_PASSWORD=${MONGO_PASSWORD}
export MONGODB_SSL=true
export MONGODB_SSL_VALIDATE=false  # Set to false when using self-signed certificate
export MONGODB_SSL_CA=  # Content of CA's certificate
export MONGODB_SSL_KEY=`cat ./certs/server.key`  # Content of the key (default: read ./certs/server.key)
export MONGODB_SSL_CERT=`cat ./certs/server.cert`  # Content of the certificate (default: read ./certs/server.cert)

## Initialization (credentials works with local and SSO auth strategies)
export APP_INIT_ADMIN_EMAIL=thomas.schaffter@sagebase.org
export APP_INIT_ADMIN_PASSWORD=admin
export APP_INIT_DB_SEED_NAME=default

## Enabling local authentication
export AUTH_LOCAL=true

## Enabling Google OAuth 2.0
export OAUTH_GOOGLE_ID=
export OAUTH_GOOGLE_SECRET=
# export OATH_GOOGLE_ID=$(aws ssm get-parameters --region us-east-1 --names OATH_GOOGLE_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export OAUTH_GOOGLE_SECRET=$(aws ssm get-parameters --region us-east-1 --names OAUTH_GOOGLE_SECRET --with-decryption --query Parameters[0].Value | sed 's\"\\g')

## Enabling Google SAML
export SAML_GOOGLE_ENTRY_POINT=
export SAML_GOOGLE_ISSUER=
# export SAML_GOOGLE_ENTRY_POINT=$(aws ssm get-parameters --region us-east-1 --names SAML_GOOGLE_ENTRY_POINT --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export SAML_GOOGLE_ISSUER=$(aws ssm get-parameters --region us-east-1 --names SAML_GOOGLE_ISSUER --with-decryption --query Parameters[0].Value | sed 's\"\\g')

## Enabling Microsoft Azure AD OpenID Connect (demo)
export AZUREAD_OPENIDCONNECT_IDENTITY_METADATA=
export AZUREAD_OPENIDCONNECT_CLIENT_ID=
export AZUREAD_OPENIDCONNECT_CLIENT_SECRET=
# export AZUREAD_OPENIDCONNECT_IDENTITY_METADATA=$(aws ssm get-parameters --region us-east-1 --names AZUREAD_OPENIDCONNECT_IDENTITY_METADATA --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export AZUREAD_OPENIDCONNECT_CLIENT_ID=$(aws ssm get-parameters --region us-east-1 --names AZUREAD_OPENIDCONNECT_CLIENT_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export AZUREAD_OPENIDCONNECT_CLIENT_SECRET=$(aws ssm get-parameters --region us-east-1 --names AZUREAD_OPENIDCONNECT_CLIENT_SECRET --with-decryption --query Parameters[0].Value | sed 's\"\\g')

## Enabling Roche Azure AD
export ROCHE_AZURE_AD_IDENTITY_METADATA=
export ROCHE_AZURE_AD_CLIENT_ID=
export ROCHE_AZURE_AD_CLIENT_SECRET=
# export ROCHE_AZURE_AD_IDENTITY_METADATA=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_IDENTITY_METADATA --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export ROCHE_AZURE_AD_CLIENT_ID=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_CLIENT_ID --with-decryption --query Parameters[0].Value | sed 's\"\\g')
# export ROCHE_AZURE_AD_CLIENT_SECRET=$(aws ssm get-parameters --region us-east-1 --names ROCHE_AZURE_AD_CLIENT_SECRET --with-decryption --query Parameters[0].Value | sed 's\"\\g')

# NEO4J
export NEO4J_USERNAME=neo4j
export NEO4J_PASSWORD=neo4jpassword

# PROVENANCE
export PROVENANCE_API_SERVER_PROTOCOL=http
export PROVENANCE_API_SERVER_IP=localhost
export PROVENANCE_API_SERVER_PORT=8080
export PROVENANCE_API_SERVER_PATH=/rest/v1

docker login $DOCKERREGISTRY -u $DOCKERUSER -p $DOCKERPASSWORD

echo Stopping docker-compose
docker stop $(docker ps -a -q)
docker-compose down --remove-orphans || true
echo Starting docker-compose
docker-compose pull && docker-compose up -d