# twonky-on-systemd
A script and supporting files to install Twonky Media Server 8.5.x in to a Raspbian/Debian Buster install and integrate it 
directly with systemd for startup control.

|File|Description|
|---|---|
|README.md|This file|
|install-twonky-85x.sh|A script to download (if necessary) the install files for Twonky 8.5.1 and to install them as a service on Linux|
|remove-twonky.sh|A script to stop a running twonky instance and remove the files installed by install-twonky-85x.sh and any files created by a running twonky instance|
|twonky.service|A unit file to define how systemd should stop, start or restart twonky|
|wipe-twonky-db.sh|A file to remove the working files used by the twonky server|
