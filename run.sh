#!/bin/sh

STATION_ID=$1
DURATION_IN_MINUTES=$2
FILENAME_PREFIX="$3"

date_str=$(date "+%Y-%m-%d-%H_%M")

setup_scripts() {
  # radish
  curl https://raw.githubusercontent.com/uru2/radish/refs/heads/master/radi.sh -o /usr/local/bin/rec_radiko.sh.tmp --max-time 30
  if [ $? -eq 0 ]; then
    echo "Latest radi.sh was downloaded successfully and renamed to rec_radiko.sh."
    chmod +x /usr/local/bin/rec_radiko.sh.tmp
    mv /usr/local/bin/rec_radiko.sh.tmp /usr/local/bin/rec_radiko.sh
  else
    echo "Failed to download latest radi.sh. The script in docker image will be used."
  fi
}

setup_scripts

# choose rec_type and replace station id
case "STATION_ID" in
  tokyo-r1)
    rec_type=nhk
    replaced_station_id=$STATION_ID
    ;;
  NHK2)
    rec_type=nhk
    replaced_station_id=r2
    ;;
  tokyo-fm)
    rec_type=nhk
    replaced_station_id=$STATION_ID
    ;;
  *)
    rec_type=radiko
    replaced_station_id=$STATION_ID
esac


# record and save
/usr/local/bin/rec_radiko.sh -t $rec_type -s $replaced_station_id -d $DURATION_IN_MINUTES -o "$WORKING_DIR/${FILENAME_PREFIX}_${date_str}.m4a"

