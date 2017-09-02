#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REVISION=$1

DEPLOYMENT_GROUP=`aws cloudformation describe-stacks --stack-name webapp-example --query "Stacks[0].Outputs | [?OutputKey == 'DeploymentGroup'].OutputValue" --output text`
DEPLOYMENT_BUCKET=`aws cloudformation describe-stacks --stack-name webapp-example --query "Stacks[0].Outputs | [?OutputKey == 'DeploymentBucket'].OutputValue" --output text`
APPLICATION_NAME=`aws cloudformation describe-stacks --stack-name webapp-example --query "Stacks[0].Outputs | [?OutputKey == 'ApplicationName'].OutputValue" --output text`

aws deploy push --application-name $APPLICATION_NAME \
	--s3-location s3://$DEPLOYMENT_BUCKET/$REVISION \
	--source $DIR/../webapp

aws deploy create-deployment --application-name $APPLICATION_NAME \
	--s3-location bucket=$DEPLOYMENT_BUCKET,key=$REVISION,bundleType=zip \
	--deployment-group-name $DEPLOYMENT_GROUP