# phccp-infra


```
awsmfa --identity-profile sandbox --target-profile tyu@sandbox --token 887161
sceptre --var "profile=sandbox.admin" --var "region=us-east-1" launch develop/code_deploy_essentials.yaml
```