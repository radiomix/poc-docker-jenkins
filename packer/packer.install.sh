#!/bin/bash

# install packer: download zip, unzip at /usr/local/bin

wget https://dl.bintray.com/mitchellh/packer/0.5.2_linux_amd64.zip -O packer.zip
sudo unzip -o -d /usr/local/bin packer.zip
rm packer.zip
