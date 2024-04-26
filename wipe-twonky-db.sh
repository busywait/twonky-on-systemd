#!/bin/bash
#set -x
#trap read debug

# Some twonkyserver.ini options only affect the collection of data, and have no 
# effect after metadata has been added to the db. 

# This script assumes that the twonky home (or working) directory and appdata options 
# are /var/opt/twonky. In 8.5.2 dbdir, tncache and the other working files are 
# directly underneath. Other configurations/earlier versions write these files 
# in .twonky/twonkyserver.

echo This will stop the twonky service, remove the metadata cache DBs and thumbnails. 

# shutdown any running servers
sudo systemctl stop twonky

# remove the db and caches, leave the config file /etc/config/twonky/twonkyserver.ini
# and license key /var/opt/twonky/.lynxtechnology/token in place
sudo rm -rf /var/opt/twonky/db
sudo rm -rf /var/opt/twonky/db.info
sudo rm -rf /var/opt/twonky/db.info_bak

# restart twonky, and it will start indexing based on the existing configuration
sudo systemctl start twonky
