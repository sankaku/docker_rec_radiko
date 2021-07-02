# docker_rec_radiko
[rec_radiko.sh](https://gist.github.com/matchy256/3956266)と[rec_nhk.sh](https://gist.github.com/matchy256/5310409)の力を借りて[radiko.jp](http://radiko.jp)を録音する。

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

## Fargateで動かす場合...
1. DockerイメージをECRにpush  
  [通常の手順](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)に従う。

    ```sh
    $ aws ecr create-repository --repository-name <REPOSITORY_NAME>
    # (前のコマンドで<repositoryUri>が取得できている)
    $ docker build . -t <repositoryUri>
    $ aws ecr get-login --no-include-email
    # 前のコマンドで出力された文字列をそのまま実行してログインする
    $ docker push <repositoryUri>
    ```
2. ロールとネットワークのCloudFormationスタックを作成  
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-roles-stack --template-body file://./cf/roles.yaml --capabilities CAPABILITY_NAMED_IAM
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-network-stack --template-body file://./cf/network.yaml
    ```
3. ECSクラスタのCloudFormationスタックを作成  
  ロールとネットワークのスタックが作成完了してから実行する。
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-cluster-stack --template-body file://./cf/cluster.yaml
    ```
4. タスクのCloudFormationスタックを作成  
  ECSクラスタのスタックが作成完了してから実行する。  

  `cf/tasks/mytask.yaml` を自作する。  
  テンプレートは `cf/task.template.yaml` 。 以下のパラメータを修正すればいい:
  - ECSCommand
  - ECSTaskSchedulerPattern  
    **UTCで書くこと**
  - ECSTaskName
  - ImageName
  - S3BucketName
  - [optional] ECSTaskCpu
  - [optional] ECSTaskMemory
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-task-stack --template-body file://./cf/tasks/mytask.yaml
    # 複数のタスクを一度に作成する場合はこんなふうにする
    $ for f in `ls ./cf/tasks/`; do aws cloudformation create-stack --stack-name docker-rec-radiko-task-stack-`echo $f | sed "s/\..*$//"` --template-body file://./cf/tasks/$f; done
    ```


## Acknowledgements
+ [matchy256/rec_radiko.sh](https://gist.github.com/matchy256/3956266)
+ [matchy256/rec_nhk.sh](https://gist.github.com/matchy256/5310409)

## License
MIT License
