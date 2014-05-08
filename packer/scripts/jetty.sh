#!/bin/bash

# 
echo "Installing the jetty cookbook into /home/ubuntu/cookbooks/"

# create a cookbook dir
mkdir -p /home/ubuntu/cookbooks/

# get the jetty cookbook and unzip it
wget https://github.com/opscode-cookbooks/jetty/archive/master.zip
unzip master.zip -d /home/ubuntu/cookbooks/

# grant ownership to the ubuntu user
chown -R ubuntu.ubuntu /home/ubuntu/cookbooks/jetty*

  
