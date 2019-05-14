# docker_rec_radiko
[radiko.jp](http://radiko.jp) recorder with docker and the great power of [rec_radiko.sh](https://gist.github.com/matchy2/3956266).

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

for NHK2([2019年度 radiko経由のNHKラジオの配信について](https://www.nhk.or.jp/pr/keiei/otherpress/pdf/20190322.pdf))
```sh
$ ./nhk_docker_run.sh NHK2 <DURATION_IN_MINUTES> <DIRECTORY_PATH_ON_HOST> <FILENAME_PREFIX>

```

### crontab example
[crontab_example.txt](./crontab_example.txt)

## Acknowledgements
+ [matchy2/rec_radiko.sh](https://gist.github.com/matchy2/3956266)
+ [matchy2/rec_nhk.sh](https://gist.github.com/matchy2/5310409)

## License
MIT License
