#!/bin/bash
#set -x
#trap read debug

# remove from init
sudo systemctl stop twonky
sudo systemctl disable twonky

# shutdown any running servers
sudo killall -s TERM twonkystarter
sudo killall -s TERM twonky

# remove anything that the install script creates
sudo rm /etc/systemd/system/twonky.service
sudo rm -rf /var/run/twonky
sudo rm -rf /var/opt/twonky
sudo rm -rf /var/log/twonky
sudo rm -rf /etc/twonky
sudo rm -rf /opt/twonky
sudo userdel -r -f twonky

# reload systemd service configurations
sudo systemctl daemon-reload

# remove things that might have been accidentally created
if [ -e /etc/twonkyserver.ini ]
then
        sudo rm /etc/twonkyserver.ini
fi
if [ -e /var/run/mediaserver.pid ]
then
        sudo rm /var/run/mediaserver.pid
fi
if [ -e /var/run/twonky-mediaserver.pid ]
then
        sudo rm /var/run/twonky-mediaserver.pid
fi
