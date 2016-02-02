#!/bin/bash

if [[ "$(whoami)" != "root" ]]
then
    echo "Switching to root..."
      exec sudo -E -- "$0" "$@"
fi


# Ensure that APT system can deal with HTTPS
apt-get -y install apt-transport-https

echo "ADDING APT-KEY FOR GET.DOCKER.IO..."
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D


echo "SETTING UP SOURCES FOR GET.DOCKER.IO..."
echo 'deb http://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list

export DEBIAN_FRONTEND=noninteractive

echo "UPDATING SYSTEM..."
apt-get -y update
apt-get -y upgrade

echo "INSTALLING KERNEL EXTENSIONS..."
apt-get -y install linux-image-extra-$(uname -r)

echo "INSTALLING DOCKER.IO"
apt-get -y install docker.io

echo "ADDING UBUNTU USER TO DOCKER GROUP..."
usermod -aG docker ubuntu

echo "DONE."

