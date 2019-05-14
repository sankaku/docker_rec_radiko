#!/bin/sh
docker run --rm --mount type=bind,source=$3,target=/usr/volume docker_rec_radiko:latest /usr/local/bin/rec_nhk.sh $1 $2 /usr/volume $4
# docker run --rm -v $3:/usr/volume docker_rec_radiko:latest /usr/local/bin/rec_radiko.sh $1 $2 /usr/volume $4

