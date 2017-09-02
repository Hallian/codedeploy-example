# codedeploy-example

# CodeDeploy

## Appspec

### Files

[See AWS Documentation on files](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-files.html)

### Hooks

[AWS Docs on hooks](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)

## Deploy

```
cd webapp
npm install
npm run deploy-webapp -- webapp-1
```

# CloudFormation

## Create stack

```
aws cloudformation create-stack \
	--stack-name webapp-example \
	--template-body=file://webapp.cloudformation.yml \
	--capabilities CAPABILITY_IAM
```