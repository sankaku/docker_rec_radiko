#!/bin/sh
docker run --rm --mount type=bind,source=$3,target=/recorded docker_rec_radiko:latest /usr/local/bin/run.sh $1 $2 $4
# docker run --rm -v $3:/recorded docker_rec_radiko:latest /usr/local/bin/run.sh $1 $2 $4

