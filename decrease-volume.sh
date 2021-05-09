#!/bin/bash

[ -z "$1" ] && echo "Provide requested volume as the first parameter (0-100)" && exit 1
[ ! -z "${1##[0-9]*}" ] && echo "First parameter must be a number (0-100)" && exit 2

source /opt/volumio-scripts/common.sh

REQUESTED_VOLUME=$1
CURRENT_VOLUME=`volumio volume`


if [ "$CURRENT_VOLUME" -gt "$REQUESTED_VOLUME" ]; then
    log "Decreasing volume from $CURRENT_VOLUME to $REQUESTED_VOLUME."
    volumio volume $REQUESTED_VOLUME
    echo
else
    log "Current volume $CURRENT_VOLUME is already below or equal to requested value $REQUESTED_VOLUME. Ignoring."
fi

illuminate 10

