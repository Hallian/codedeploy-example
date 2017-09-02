# codedeploy-example

# CodeDeploy

## Appspec

### Files

[See AWS Documentation on files](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-files.html)

### Hooks

[AWS Docs on hooks](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)

## Deploy

```
npm run describe-stack
aws deploy push --application-name <MyAppName> \
    --s3-location s3://<MyBucketName>/<MyNewAppBundleName> \
    --source webapp
```

# CloudFormation

## Create stack

```
aws cloudformation create-stack \
	--stack-name webapp-example \
	--template-body=file://webapp.cloudformation.yml \
	--capabilities CAPABILITY_IAM
```


aws deploy push --application-name webapp-example-WebappApplication-7ZQAKNAFZKME \
    --s3-location s3://webapp-example-webappdeploymentbucket-kr1ihbwlwc4k/webapp-1 \
    --source webapp


aws deploy create-deployment --application-name webapp-example-WebappApplication-7ZQAKNAFZKME --s3-location bucket=webapp-example-webappdeploymentbucket-kr1ihbwlwc4k,key=webapp-1,bundleType=zip,eTag=eda85a63ed3321ba1592790c3a13ca4c --deployment-group-name 	webapp-example-WebappDeploymentGroup-1VFRA7H6AFRCC
