About
-----

Volumio configuration template. Tested on:

  * Raspberry Pi 1 Model B
  * USB Wifi Adapter (148f:5370 -> modinfo rt2800usb)
  * Creative Pebble V2 speakers connected by 3.5mm jack (powered by USB)
  * Volumio 3.x
    * cat /etc/os-release -> Raspbian GNU/Linux 10 (buster)



Installation
------------

  * dd if=Volumio-3.198-2022-01-24-pi.img of=MY-SDCARD-DEVICE  bs=4M status=progress



Configuration - UI
------------------

Sources

  * Disable "UPNP Renderer"
  * Disable "Shairport-sync"
  * Disable "DLNA Browser"

Network

  * Disable Hostspot
  * Change DNS (1.1.1.2, 1.0.0.2)

System

  * Disable sending UI stats
    * this disables sending data to facebook and google



Configuration - SSH
-------------------

  * Temporarily enable SSH: http://192.168.xxx.xxx/dev/

  * Change default passwords

  * Update and fix after the update
    * sudo apt update
    * sudo apt upgrade
    * reboot

  * Install tools 
    * sudo apt install vim
    * select-editor
    * sudo apt install cron exim4-base- (install cron without dependencies)
    * sudo apt install espeak

  * Set timezone
    * sudo dpkg-reconfigure tzdata

  * Disable the HDMI port (to save some power on battery)
    * https://raspberry-projects.com/pi/pi-hardware/raspberry-pi-zero/minimising-power-consumption
    * sudo echo "/opt/vc/bin/tvservice -o" >> /etc/rc.local   (and correct file manually)



Download scripts
----------------

```
export CUSTOM_VOLUMIO=/opt/volumio-scripts
mkdir -p $CUSTOM_VOLUMIO
cd $CUSTOM_VOLUMIO
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/common.sh
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/play-default-playlist.sh
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/decrease-volume.sh
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/illuminate.sh
chmod +x *.sh

```



Configure cron
--------------

Morning settings
```
echo "30  9   * * *   volumio volumio volume 35 >> /home/volumio/cron.log" >> /etc/crontab
```

Night settings - decrease volume and stop playing
```
echo " 0 23   * * *   volumio /opt/volumio-scripts/decrease-volume.sh 34 >> /home/volumio/cron.log" >> /etc/crontab
echo "30 23   * * *   volumio /opt/volumio-scripts/decrease-volume.sh 30 >> /home/volumio/cron.log" >> /etc/crontab 
echo " 0  0   * * *   volumio /opt/volumio-scripts/decrease-volume.sh 24 >> /home/volumio/cron.log" >> /etc/crontab 
echo "30  0   * * *   volumio /opt/volumio-scripts/decrease-volume.sh 19 >> /home/volumio/cron.log" >> /etc/crontab
echo " 0  1   * * *   volumio (date && /usr/local/bin/volumio stop) >> /home/volumio/cron.log" >> /etc/crontab
```

Other
```
echo '@reboot volumio echo "\n\n\nStarting Volumio ..." >> /home/volumio/cron.log' >> /etc/crontab
echo '@reboot volumio espeak -a 200 "Volumio is starting." --stdout | aplay -Dhw:1,0' >> /etc/crontab
```



Autostart web radio
-------------------

Add playlist

```
# Run as "volumio" user
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/playlists/default-morning.json -O /data/playlist/default-morning.json 
wget https://github.com/tomikmar/tm-volumio-setup/raw/master/playlists/default-evening.json -O /data/playlist/default-evening.json 
```

Add start script

```
# Run as "root"
export CUSTOM_VOLUMIO=/opt/volumio-scripts
echo "@reboot volumio $CUSTOM_VOLUMIO/play-default-playlist.sh >> /home/volumio/cron.log" >> /etc/crontab
```



Add illumination
----------------

Allow users to enable/disable wifi activity LED to visualize some actions.

```
# Run as "root"
echo "@reboot root chmod o+w /sys/class/leds/rt2800usb-phy0::assoc/brightness" >> /etc/crontab
```



Notes - sound tools
-------------------

How Volumio controls volume?

```
amixer -c 1 -M get 'Headphone'
amixer -c 1 -M set 'Headphone' 60%
grep amixer /volumio/app/volumecontrol.js
```

Other tools

```
aplay -l
speaker-test -Dhw:1,0 -c2 -twav -l7

alsamixer -c 1
amixer -c 1 scontents
amixer -c 1 contents

alsactl monitor
alsactl store / restore
/var/lib/alsa/asound.state
```



Notes (WIP)
-----------

```
sudo nmap -sS -p 22,80,111,139,445,3000,3001,3005,5000,6599,6600,7777,55669 192.168.xxx.xxx
dpkg -S `which rpcbind`
dpkg -L rpcbind
```

```
ls -l /etc/rc*.d/*smbd
ls -l /etc/rc*.d/*nmbd
ls -l /etc/rc*.d/*winbind
ls -l /etc/rc*.d/*samba-ad-dc
ls -l /etc/rc*.d/*avahi-daemon
ls -l /etc/rc*.d/*rpcbind
```

```
update-rc.d smbd remove
update-rc.d nmbd remove
update-rc.d winbind remove
update-rc.d samba-ad-dc remove

#? update-rc.d avahi-daemon remove
#? update-rc.d rpcbind remove
```

