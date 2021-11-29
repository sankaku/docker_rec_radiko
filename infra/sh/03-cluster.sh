#!/bin/sh

cd `dirname $0`
. ./constants.txt

CFN_FILEPATH=../cfn/cluster.yaml
CFN_STACK_NAME=$PROJECT_NAME-Cluster

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME \
                            ECSClusterName=Cluster

