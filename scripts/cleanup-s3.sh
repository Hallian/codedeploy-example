#!/usr/bin/env bash

STACK_OUTPUTS=`aws cloudformation describe-stacks --stack-name webapp-example --query "Stacks[0].Outputs[].[OutputValue]" --output text`
DEPLOYMENT_BUCKET=`echo "$STACK_OUTPUTS" | grep webappdeploymentbucket`

aws s3 rm s3://$DEPLOYMENT_BUCKET --recursive
