#!/bin/sh

cd `dirname $0`
. ../constants.txt

CFN_FILEPATH=../../cfn/task.yaml

##### ここから編集
# ECSタスク名
ECS_TASK_NAME="TemplateTask"
# ECSタスクで実行するコマンド引数
ECS_COMMAND_ARGS="TBS, 1, サンプルの番組名"
# タスクを実行するスケジュールをcronで書く(UTC)
SCHEDULE_PATTERN_UTC="0/3 * * * ? *"

# (必要な場合に変更) CPU
ECS_TASK_CPU=256
# (必要な場合に変更) メモリ
ECS_TASK_MEMORY=512
##### ここまで編集

CFN_STACK_NAME="$PROJECT_NAME-Task-$ECS_TASK_NAME"

aws cloudformation deploy --template-file $CFN_FILEPATH \
                          --stack-name $CFN_STACK_NAME \
                          --parameter-overrides \
                            ProjectName=$PROJECT_NAME \
                            ECSCommandArgs="$ECS_COMMAND_ARGS" \
                            ECSTaskSchedulerPattern="$SCHEDULE_PATTERN_UTC" \
                            ECSTaskName=$ECS_TASK_NAME \
                            ImageVersion=$IMAGE_VERSION \
                            S3BucketName=$S3_BUCKET_NAME \
                            ECSTaskCpu=$ECS_TASK_CPU \
                            ECSTaskMemory=$ECS_TASK_MEMORY

