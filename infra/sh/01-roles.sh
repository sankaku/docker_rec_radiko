#!/bin/sh

cd `dirname $0`
. ./constants.txt

CFN_FILEPATH=../cfn/roles.yaml
CFN_STACK_NAME=$PROJECT_NAME-Roles

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --capabilities CAPABILITY_NAMED_IAM \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME

