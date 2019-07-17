# CodeDeploy application for the PHC Collaboration Portal
This repository provides the instructions needed by an AWS CodeDeploy app to
deploy the PHC Collaboration Portal developed by Sage Bionetworks and Roche/GNE.

https://github.com/Sage-Bionetworks/PHCCollaborationPortal

## Manual deployment of the Portal

1. Clone this repository
2. Generates self-signed SSL certificate (run below)
3. Update the environment variables in `docker-compose.yml`
  - phccp > DOMAIN (e.g. `https://localhost` if testing the portal client and server locally)
4. `docker-compose up`

## Generating SSL certificates
The portal requires SSL certificates for the following components

- Express server
- MongoDB

The following code generates the certificates expected by the portal without
prompt. From the root of this repository:

```bash
export CERTS_DIR=certs
mkdir $CERTS_DIR
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
  -subj "/C=US/ST=Washington/L=Seattle/O=Sage Bionetworks/CN=www.sagebionetworks.org" \
  -keyout $CERTS_DIR/server.key -out $CERTS_DIR/server.cert
cat $CERTS_DIR/server.key $CERTS_DIR/server.cert > $CERTS_DIR/mongodb.pem
```
