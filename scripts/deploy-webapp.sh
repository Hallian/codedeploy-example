#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REVISION=$1

STACK_OUTPUTS=`aws cloudformation describe-stacks --stack-name webapp-example --query "Stacks[0].Outputs[].[OutputValue]" --output text`
DEPLOYMENT_BUCKET=`echo "$STACK_OUTPUTS" | grep webappdeploymentbucket`
DEPLOYMENT_GROUP=`echo "$STACK_OUTPUTS" | grep WebappDeploymentGroup`
APPLICATION_NAME=`echo "$STACK_OUTPUTS" | grep WebappApplication`

aws deploy push --application-name $APPLICATION_NAME \
	--s3-location s3://$DEPLOYMENT_BUCKET/$REVISION \
	--source $DIR/../webapp > /dev/null

aws deploy create-deployment --application-name $APPLICATION_NAME \
	--s3-location bucket="$DEPLOYMENT_BUCKET",key="$REVISION",bundleType=zip \
	--deployment-group-name $DEPLOYMENT_GROUP