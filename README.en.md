# docker_rec_radiko
[radiko.jp](http://radiko.jp) recorder with docker and the great power of [rec_radiko.sh](https://gist.github.com/matchy256/3956266) and [rec_nhk.sh](https://gist.github.com/matchy256/5310409).

## Requirements
+ Docker
+ Location(Japan)

## Preparation

```sh
$ docker build . -t docker_rec_radiko
```

## Usage

```sh
$ ./radiko_docker_run.sh <STATION_ID> <DURATION_IN_MINUTES> <DIRECTORY_PATH_ON_HOST> <FILENAME_PREFIX>
```

### crontab example
[crontab_example.txt](./crontab_example.txt)

## If you want to run on Fargate...
1. Push the Docker image to ECR  
  Please follow [the standard procedure](https://docs.aws.amazon.com/en_pv/AmazonECR/latest/userguide/docker-push-ecr-image.html).

    ```sh
    $ aws ecr create-repository --repository-name <REPOSITORY_NAME>
    # (You'll have gotten the <repositoryUri> by the previous command)
    $ docker build . -t <repositoryUri>
    $ aws ecr get-login --no-include-email
    # Please log in just by executing the output string of the previous command
    $ docker push <repositoryUri>
    ```
2. Create roles & network stacks on CloudFormation  
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-roles-stack --template-body file://./cf/roles.yaml --capabilities CAPABILITY_NAMED_IAM
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-network-stack --template-body file://./cf/network.yaml
    ```
3. Create ECS cluster stack on CloudFormation  
  Execute after the roles & network stacks are created.
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-cluster-stack --template-body file://./cf/cluster.yaml
    ```
4. Create task stack(s) on CloudFormation  
  Execute after the ECS cluster stack is created.  

  Please write your `cf/tasks/mytask.yaml`.  
  The template file is `cf/task.template.yaml`. All you have to do is to modify these parameters:
  - ECSCommand
  - ECSTaskSchedulerPattern  
    **Specify in UTC**
  - ECSTaskName
  - ImageName
  - S3BucketName
  - [optional] ECSTaskCpu
  - [optional] ECSTaskMemory
    ```sh
    $ aws cloudformation create-stack --stack-name docker-rec-radiko-task-stack --template-body file://./cf/tasks/mytask.yaml
    # Execute like this if you create several tasks at once
    $ for f in `ls ./cf/tasks/`; do aws cloudformation create-stack --stack-name docker-rec-radiko-task-stack-`echo $f | sed "s/\..*$//"` --template-body file://./cf/tasks/$f; done
    ```


## Acknowledgements
+ [matchy256/rec_radiko.sh](https://gist.github.com/matchy256/3956266)
+ [matchy256/rec_nhk.sh](https://gist.github.com/matchy256/5310409)

## License
MIT License
