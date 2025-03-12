#!/bin/bash
#set -x
#trap read debug

TWONKY_DOWNLOAD=http://download.twonky.com/8.5.2/
# Visit https://download.twonky.com/ to see the available versions

# Choose a build according to CPU arch and OS
# ...Intel 64-bit
#TWONKY_FILE=twonky-i686-glibc-2.9-8.5.2.zip
# ...Pi 4b with 64-bit OS
TWONKY_FILE=twonky-armv8-8.5.2.zip
# ...Pi 3b or 4b with 32-bit OS
#TWONKY_FILE=twonky-armel-glibc-2.15-hf-8.5.2.zip

echo Check if the Twonky zip package has been downloaded already
if [ ! -e ./$TWONKY_FILE ]
then
        echo downloading from $TWONKY_DOWNLOAD
        wget $TWONKY_DOWNLOAD$TWONKY_FILE
else
        echo using existing twonky package
        ls -l $TWONKY_FILE
fi

echo Creating a no-login service account for twonky mediaserver to avoid running as root
sudo useradd --system --no-create-home --shell /usr/sbin/nologin twonky

echo Make directories for the working files and folders
sudo mkdir /var/opt/twonky
# Creating directories when we only need a single file saves hassle later if,
# for example, the log file gets deleted then the twonky service has no
# permission to recreate it. Same with .ini in /etc/twonky. With permission to
# write in to its own directories the twonky service will recreate any missing file.
echo Make a directory for log files
sudo mkdir /var/log/twonky
echo Make a directory for the config file
sudo mkdir /etc/twonky

echo Unpack the twonky install package to our install location
sudo unzip -d /opt/twonky ./$TWONKY_FILE

echo Provide the path to ffmpeg to enable thumbnail creation for videos and images
sudo sh -c "echo /usr/bin > /opt/twonky/cgi-bin/ffmpeg.location"
echo Provide the path to convert \(ImageMagick\) to enable thumbnail creation for photos
sudo sh -c "echo /user/bin > /opt/twonky/cgi-bin/convert.location"

echo Change the ownership of all writable folders to twonky.twonky
sudo chown twonky.twonky /var/opt/twonky
sudo chown twonky.twonky /var/log/twonky
sudo chown twonky.twonky /etc/twonky
# /var/run/twonky will be managed by systemd

echo Twonky does not need to write to the install folder so change the ownership to root.root
sudo chown root.root /opt/twonky

echo Set the home folder for the twonky service, to allow caching of working files like thumbnails and the database
sudo usermod -d /var/opt/twonky twonky

echo Supply additional defaults for this install
sudo sh -c "echo \# Point twonky to the writable folders in this install >> /opt/twonky/twonkyserver-default.ini"
# In twonky 8.5.1 cachedir is the only folder that twonky doesn't put in to its home directory, instead trying to 
# write in the current (working) directory. Fix this by defining either of appdata or cachedir.
#sudo sh -c "echo cachedir=/var/opt/twonky/cache >> /opt/twonky/twonkyserver-default.ini"
sudo sh -c "echo appdata=/var/opt/twonky >> /opt/twonky/twonkyserver-default.ini"

echo Supply config changes for the file scanner to help group tracks in the navigation
sudo sh -c "echo \# Minimise unexpected metadata manipulations >> /opt/twonky/twonkyserver-default.ini"
# Alternatively, or additionally: see view-patch.sh
sudo sh -c "echo force_albumartist=0 >> /opt/twonky/twonkyserver-default.ini"
sudo sh -c "echo scan_compilation_flag=2 >> /opt/twonky/twonkyserver-default.ini"

echo Add a systemd unit file to run Twonky as a service on startup
sudo cp ./twonky.service /etc/systemd/system/twonky.service
sudo systemctl daemon-reload
sudo systemctl enable twonky.service

echo Start Twonky, configure at http://localhost:9000/
# sudo -u twonky /opt/twonky/twonkystarter --mspid /var/run/twonky/twonky-mediaserver.pid --inifile /etc/twonky/twonkyserver.ini --logfile /var/log/twonky/twonky.log
sudo systemctl start twonky.service
