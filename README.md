# docker_rec_radiko
[rec_radiko.sh](https://gist.github.com/matchy256/3956266)と[rec_nhk.sh](https://gist.github.com/matchy256/5310409)の力を借りて[radiko.jp](http://radiko.jp)を録音する。

-> 2025年4月に[radish](https://github.com/uru2/radish)に移行。
現在のリポジトリの内容でdocker buildして、ECRリポジトリのDockerイメージをそれと置き換えれば、他の設定はそのままで使えるはず。


## 必要なもの
+ Docker
+ 場所(日本)

## 準備

```sh
$ docker build . -t docker_rec_radiko
```

## 使い方

```sh
$ ./radiko_docker_run.sh <放送局ID> <録音時間(分)> <保存先ディレクトリのホスト側パス> <ファイルプレフィクス>
```

### crontabの例
[crontab_example.txt](./crontab_example.txt)

## Fargateで動かす場合
[2021/11/29までの状態](https://github.com/sankaku/docker_rec_radiko/tree/v1.1)とは大きく変わっている。  
そちらで作ったものを残したまま以下を実行しても、両立でき、問題は起きない。

### 共通インフラの作成
1. 定数ファイルのテンプレートのコピー  
   ```sh
   cp ./infra/sh/constants.template.txt ./infra/sh/constants.txt
   ```
1. 定数の設定  
   `./infra/sh/constants.txt` に定数が定義されているので、必要に応じて変更する。  
   特に変更する可能性が高いのは下記の定数。
   - S3_BUCKET_NAME  
     これは **必ず設定すること** 。録音したファイルを保存するS3バケット名。あらかじめ作成しておく。
   - VPC_CIDR  
     VPCのIPアドレスの範囲。必要があれば変更する。
   - SUBNET_CIDR_BLOCK  
     サブネットのIPアドレスの範囲。必要があれば変更する。
1. ロールの作成  
   ```sh
   ./infra/sh/01-roles.sh
   ```
1. ネットワークの作成  
   ```sh
   ./infra/sh/02-network.sh
   ```
1. ECSクラスタの作成  
   ```sh
   ./infra/sh/03-cluster.sh
   ```
1. ECRリポジトリの作成  
   ```sh
   ./infra/sh/04-ecr.sh
   ```
1. 作成したECRリポジトリのリポジトリURIをコピー  
   AWSコンソールでECRリポジトリを確認する。またはCloudFormationのECRスタックのOutputsタブでOutputRepositoryUriにある文字列。  
   `XXXXXXXXXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/docker_rec_radiko_with_fargate/recorder` のようなURIのはず。
1. DockerイメージをECRにpush  
  [通常の手順](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)に従う。
    ```sh
    $ docker build . -t <リポジトリURI>
    $ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <リポジトリURI>
    $ docker push <リポジトリURI>
    ```

### ECSタスクの作成
ECSタスクは番組ごとに作成する。1つのECSタスクは1つのシェルスクリプトに対応する。
1. シェルスクリプトのテンプレートをコピー  
   ```sh
   cp ./infra/sh/tasks/task.template.sh ./infra/sh/tasks/my_program.sh
   ```
1. コピーしたシェルスクリプトの定数部を修正  
   - ECS_TASK_NAME  
     ECSタスク名。アルファベットと数字で書く。
   - ECS_COMMAND_ARGS  
     ECSタスクで実行するコマンド引数。  
     `<放送局ID>, <録音時間(分)>, <ファイルプレフィクス>` を書く。ファイルプレフィクスは日本語OK。
     テンプレートは `cf/task.template.yaml` 。 以下のパラメータを修正すればいい:
   - SCHEDULE_PATTERN_UTC  
     タスクを実行するスケジュールをcronで書く。 **UTCで書くこと。**  
     書き方は[ここ](https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions)を参照。
   - ECS_TASK_CPU  
     CPU。最低限に設定してあるので、もし足りない場合は変える。値は[ここ](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html#cfn-ecs-taskdefinition-cpu)参照。
   - ECS_TASK_MEMORY  
     メモリ。最低限に設定してあるので、もし足りない場合は変える。値は[ここ](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html#cfn-ecs-taskdefinition-memory)参照。
1. ECSタスクを作成  
   ```sh
   ./infra/sh/tasks/my_program.sh
   ```

## Acknowledgements
+ [matchy256/rec_radiko.sh](https://gist.github.com/matchy256/3956266)
+ [matchy256/rec_nhk.sh](https://gist.github.com/matchy256/5310409)
+ [uru2/radish](https://github.com/uru2/radish)

## License
MIT License
