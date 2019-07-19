# phccp-infra


```
awsmfa --identity-profile sandbox --target-profile tyu@sandbox --token 887161
sceptre --var "profile=sandbox.admin" --var "region=us-east-1" launch develop/code_deploy_essentials.yaml
```


## Save amazon secrets
No need to use amazon secrets manager as we do not use RDS and secrets rotation doesn't make any sense for us.  For our use case, only parameter store is required.  The key is created from the cloudformation script

```
KMS_KEYID=$(aws --profile sandbox.admin kms describe-key --key-id alias/phc-codedeploy-essentials/InfraKey | jq -r .KeyMetadata.KeyId)

aws --profile sandbox.admin ssm put-parameter --name DOCKER_REGISTRY --value docker.synapse.org --type SecureString --key-id $KMS_KEYID

aws --profile sandbox.admin ssm put-parameter --name DOCKER_USER --value phccp-autodeploy --type SecureString --key-id $KMS_KEYID

aws --profile sandbox.admin ssm put-parameter --name DOCKER_PASSWORD --value $DOCKERPASS --type SecureString --key-id $KMS_KEYID 

# add --overwrite to store over

aws --profile sandbox.admin  ssm get-parameter --name DOCKER_REGISTRY --with-decryption

```


