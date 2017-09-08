# AWS CodeDeploy Example

This project will demonstrate the basics of deploying an application to an Auto Scaled EC2 instance with CodeDeploy. The infrastructure
is setup is automated with CloudFormation. A NodeJS Express application will serve as a dummy application. Dependencies are preinstalled
into the AMI with Packer.

# Getting started

Well start off by creating a stack of AWS resources that we're going to use to serve our application. Use the AWS CLI to create a CloudFormation stack from `webapp.cloudformation.yml`.

```
aws cloudformation create-stack \
	--stack-name webapp-example \
	--template-body=file://webapp.cloudformation.yml \
	--capabilities CAPABILITY_IAM
```

Next we'll deploy our sample `webapp`. It's a simple Express application written in NodeJS so you'll need to install it's dependencies with npm.

```
cd webapp
npm install
```

To deploy our application we'll use aws cli to create a zip file of our sources and push it to S3.

```
# in project root
aws deploy push --application-name $APPLICATION_NAME \
	--s3-location s3://$DEPLOYMENT_BUCKET/$REVISION \
	--source webapp
```

Replace `$APPLICATION_NAME`, `$DEPLOYMENT_BUCKET` and `$REVISION` with your values. Revision can be anything but it should include an incrementing
version number, e.g. `webapp-1, webapp-2, webapp-3...`.
You can obtain the application name and deployment bucket from the example webapp stack's outputs with the following command.

```
aws cloudformation describe-stacks --stack-name webapp-example
```

Once you've pushed your new revision package to S3, the command will output a command that you can use to deploy the application to a deployment group.
It will look something like this:

```
aws deploy create-deployment --application-name $APPLICATION_NAME \
	--s3-location bucket="$DEPLOYMENT_BUCKET",key="$REVISION",bundleType=zip \
	--deployment-group-name $DEPLOYMENT_GROUP
```

That command will create a new deployment in CodeDeploy. The CodeDeploy agent on your instances will notice this and download the new revision.

## Scripting

Since it's somewhat tedious to be writing all of that all the time, it pays to have a script do it for you. The `scripts` folder contains a script
that will do all of the above in one step.

```
../scripts/deploy-webapp.sh webapp-1
```

Alternatively, you can use the convenient npm scripts registered in the scripts section of `package.json`:

```
npm run create-stack
...
npm run deploy-webapp -- webapp-1
```

npm scripts like these can be configured in the scripts section of `package.json`.

# CodeDeploy

![deployment](images/deployment.png)

## Appspec

### Files

```
files:
  - source: src
    destination: /opt/webapp
  - source: node_modules
    destination: /opt/webapp/node_modules
```

[See AWS Documentation on files](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-files.html)

### Hooks

```
hooks:
  ApplicationStop:
    - location: deployment_scripts/stop.sh
  AfterInstall:
    - location: deployment_scripts/deploy.sh
  ApplicationStart:
    - location: deployment_scripts/start.sh
```

[AWS Docs on hooks](http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)

## Deploy

```
cd webapp
npm install
npm run deploy-webapp -- webapp-1
```

# CloudFormation

![stack](images/stack.png)

## Create stack

We'll use the `aws` cli tool to create the stack.

```
aws cloudformation create-stack \
	--stack-name webapp-example \
	--template-body=file://webapp.cloudformation.yml \
	--capabilities CAPABILITY_IAM
```

However that's a bit cumbersome to type out every time so `package.json` contains a bunch of handful scripts, e.g.

```
npm run create-stack
```

## Remove stack

To remove the stack you'll first need to clean up the S3 deployment bucket. CloudFormation will refuse to delete buckets
that are not empty.

```
npm run cleanup-s3
npm run remove-stack
```

## Useful npm scripts:

```
npm run create-stack
npm run update-stack
npm run delete-stack
npm run remove-stack
npm run describe-stack
npm run describe-stack-events
npm run wait-stack-delete
npm run wait-stack-remove
npm run wait-stack-create
npm run wait-stack-update
npm run wait-stack-exists
```

# EC2

We'll run our Webapp on an Auto Scaling Group with EC2 instances. For this we're going to need an Amazon Machine Image
(AMI) with our dependencies installed. Things like the CodeDeploy agent and NodeJS. We could simply install these during
the application deployment but that would increase the deployment time. It would also be error prone due to the possibility
of OS vendors package repositories being offline for example.

## Build AMI with Packer

Packer is perfect for creating AMIs with software preinstalled in a repeatable fashion.

```
packer build webapp.packer.json
```

---
Author Nikolas Lahtinen