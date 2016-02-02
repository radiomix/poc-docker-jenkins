#!/bin/bash

if [[ "$(whoami)" != "root" ]]
then
    echo "Switching to root..."
      exec sudo -E -- "$0" "$@"
fi


# Ensure that APT system can deal with HTTPS
apt-get -y install apt-transport-https

echo "Adding apt-key for get.docker.io..."
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D


echo "Setting up sources for get.docker.io..."
echo 'deb http://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list

export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt-get -y update
apt-get -y upgrade

echo "Installing kernel extensions..."
apt-get -y install linux-image-extra-$(uname -r)

echo "Installing docker.io"
apt-get -y install docker.io

echo "Adding ubuntu user to docker group..."
usermod -aG docker ubuntu

echo "Done."

