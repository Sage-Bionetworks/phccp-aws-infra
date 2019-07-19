#mkdir -p target
#zip target/deploy.zip deploy.sh docker-compose.yml appspec.yml

S3_BUCKET=$(aws cloudformation list-exports --query "Exports[?Name=='us-east-1-phc-codedeploy-essentials-CodeDeployS3Bucket'].Value" --output text)
CODEDEPLOY_APPLICATION=$(aws cloudformation list-exports --query "Exports[?Name=='us-east-1-phc-codedeploy-CodeDeployApplication'].Value" --output text)
CODEDEPLOY_DEPLOYMENTGROUP=$(aws cloudformation list-exports --query "Exports[?Name=='us-east-1-phc-codedeploy-DeploymentGroup'].Value" --output text)

#aws s3 cp target/deploy.zip s3://$S3_BUCKET/deploy.zip



aws deploy push --application-name $CODEDEPLOY_APPLICATION --description "This is a revision for the PHC App" --ignore-hidden-files --s3-location s3://$S3_BUCKET/deploy.zip --source code-deploy

aws deploy create-deployment --application-name $CODEDEPLOY_APPLICATION --deployment-config-name CodeDeployDefault.AllAtOnce --deployment-group-name $CODEDEPLOY_DEPLOYMENTGROUP --s3-location bucket=$S3_BUCKET,key=deploy.zip,bundleType=zip
