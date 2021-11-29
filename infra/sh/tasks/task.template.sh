#!/bin/sh

cd `dirname $0`
. ../constants.txt

CFN_FILEPATH=../../cfn/task.yaml

# ここから編集
ECS_TASK_NAME="TemplateTask"
ECS_COMMAND_ARGS="TBS, 1, サンプルの番組名"
SCHEDULE_PATTERN_UTC="0/3 * * * ? *"
# ここまで編集

CFN_STACK_NAME="$PROJECT_NAME-Task-$ECS_TASK_NAME"

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME \
                            ECSCommandArgs="$ECS_COMMAND_ARGS" \
                            ECSTaskSchedulerPattern="$SCHEDULE_PATTERN_UTC" \
                            ECSTaskName=$ECS_TASK_NAME \
                            ImageVersion=$IMAGE_VERSION \
                            S3BucketName=$S3_BUCKET_NAME

