#!/bin/bash

#
# Based on: https://github.com/ch007m/my-volumio-dev
#

source /opt/volumio-scripts/common.sh

PLAYLIST_MORNING="default-morning.json"
PLAYLIST_AFTERNOON="default-morning.json"
PLAYLIST_EVENING="default-evening.json"
VOLUMIO_BASE_URL=http://localhost:3000/api/v1


until $(curl --silent --output /dev/null --head --fail ${VOLUMIO_BASE_URL}/getState); do
    logAndSay "Waiting till Volumio is up and running ..."
    sleep 10s
done


say "Just a moment."
sleep 10s
say "Almost ready."
sleep 10s
logAndSay "Volumio server is running. Starting playlist ..."


HOUR=`date +%H`
if [ $HOUR -lt 11 ]; then
    log "Starting morning playlist $PLAYLIST_MORNING ..."
    volumio volume 40
    curl "${VOLUMIO_BASE_URL}/commands/?cmd=playplaylist&name=$PLAYLIST_MORNING"
elif [ $HOUR -lt 19 ]; then
    log "Starting afternoon playlist $PLAYLIST_MORNING ..."
    volumio volume 40
    curl "${VOLUMIO_BASE_URL}/commands/?cmd=playplaylist&name=$PLAYLIST_MORNING"
else
    log "Starting evening playlist $PLAYLIST_EVENING ..."
    volumio volume 30
    curl "${VOLUMIO_BASE_URL}/commands/?cmd=playplaylist&name=$PLAYLIST_EVENING"
fi
echo

log "Playlist started."
illuminate 5

