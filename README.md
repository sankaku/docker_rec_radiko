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
$ ./radiko_docker_run.sh <CHANNEL_ID> <DURATION_IN_MINUTES> <DIRECTORY_PATH_ON_HOST> <FILENAME_PREFIX>
```

## Acknowledgements
+ [matchy2/rec_radiko.sh](https://gist.github.com/matchy2/3956266)

## License
MIT License
