# codedeploy-example

# CodeDeploy

## Appspec

### Files

[See AWS Documentation on files](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-files.html)

### Hooks

[AWS Docs on hooks](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)

## Deploy

```
aws deploy push --application-name <MyAppName> \
    --s3-location s3://<MyBucketName>/<MyNewAppBundleName> \
    --source src
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