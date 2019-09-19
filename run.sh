#!/bin/sh

STATION_ID=$1
DURATION_IN_MINUTES=$2
FILENAME_PREFIX=$3

if [ $STATION_ID = "NHK2" ]; then
  RUN_COMMAND=/usr/local/bin/rec_nhk.sh
else
  RUN_COMMAND=/usr/local/bin/rec_radiko.sh
fi

# record and save as mp3 file
$RUN_COMMAND $STATION_ID $DURATION_IN_MINUTES $WORKING_DIR $FILENAME_PREFIX
