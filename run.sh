#!/bin/sh

STATION_ID=$1
DURATION_IN_MINUTES=$2
FILENAME_PREFIX=$3

setup_scripts() {
  # rec_radiko.sh
  curl https://gist.githubusercontent.com/matchy2/3956266/raw/rec_radiko.sh -o /usr/local/bin/rec_radiko.sh.tmp --max-time 30
  if [ $? -eq 0 ]; then
    echo "Latest rec_radiko.sh was downloaded successfully."
    chmod +x /usr/local/bin/rec_radiko.sh.tmp
    mv /usr/local/bin/rec_radiko.sh.tmp /usr/local/bin/rec_radiko.sh
  else
    echo "Failed to download latest rec_radiko.sh. The script in docker image is used."
  fi

  # rec_nhk.sh
  curl https://gist.githubusercontent.com/matchy2/9515cecbea40918add594203dc61406c/raw/rec_nhk.sh -o /usr/local/bin/rec_nhk.sh.tmp --max-time 30
  if [ $? -eq 0 ]; then
    echo "Latest rec_nhk.sh was downloaded successfully."
    chmod +x /usr/local/bin/rec_nhk.sh.tmp
    mv /usr/local/bin/rec_nhk.sh.tmp /usr/local/bin/rec_nhk.sh
  else
    echo "Failed to download latest rec_nhk.sh. The script in docker image is used."
  fi
}

setup_scripts

# choose script
if [ $STATION_ID = "NHK2" ]; then
  RUN_COMMAND=/usr/local/bin/rec_nhk.sh
else
  RUN_COMMAND=/usr/local/bin/rec_radiko.sh
fi

# record and save as mp3 file
$RUN_COMMAND $STATION_ID $DURATION_IN_MINUTES $WORKING_DIR $FILENAME_PREFIX
