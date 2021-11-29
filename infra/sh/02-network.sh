#!/bin/sh

cd `dirname $0`
. ./constants.txt

CFN_FILEPATH=../cfn/network.yaml
CFN_STACK_NAME=$PROJECT_NAME-Network

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME \
                            VpcCIDR=$VPC_CIDR \
                            SubnetCIDRClock=$SUBNET_CIDR_BLOCK

