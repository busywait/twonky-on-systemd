#!/bin/bash
#set -x
#trap read debug

# Some twonkyserver.ini options only affect the collection of data, and have no 
# effect if changed after a file has been found. If you change for example 

# This assumes that the twonky home directory and appdata options are /var/opt/twonky,
# so that dbdir, tncache and the other working files are underneath in .twonky

# shutdown any running servers
sudo systemctl stop twonky

# remove the db and caches, leave the config file /etc/config/twonky/twonkyserver.ini
# and license key /var/opt/twonky/.lynxtechnology/token in place
sudo rm -rf /var/opt/twonky/.twonky/*

# restart twonky, and it will start indexing based on the existing configuration
sudo systemctl start twonky
