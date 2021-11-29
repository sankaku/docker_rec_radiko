#!/bin/sh

cd `dirname $0`
. ./constants.txt

CFN_FILEPATH=../cfn/ecr.yaml
CFN_STACK_NAME=$PROJECT_NAME-ECR

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME \
                            ProjectNameSnakeCase=$PROJECT_NAME_SNAKE_CASE \
                            RepositoryName=$REPOSITORY_NAME




