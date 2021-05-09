#!/bin/bash

[ -z "$1" ] && echo "Provide illumination time in seconds as the first parameter (0-100)" && exit 1
[ ! -z "${1##[0-9]*}" ] && echo "First parameter must be a number of seconds" && exit 2


echo 255 > /sys/class/leds/rt2800usb-phy0\:\:assoc/brightness
sleep $1
echo 0 > /sys/class/leds/rt2800usb-phy0\:\:assoc/brightness

