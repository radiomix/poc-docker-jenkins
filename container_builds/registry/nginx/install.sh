#!/bin/bash

#
# Source: http://rigprog.com/docker-recipes/registry-basic-auth.html
#

# install nginx  version > 1.3.9
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update
sudo aptitude install nginx

# copy config and auth file
sudo cp registry.conf /etc/nginx/sites-enabled/registry.conf
sudo cp registry.auth /etc/nginx/registry.auth

sudo service nginx restart


echo " To protect the registry we assume it is running on port 5000"
echo " Start your registry like:> docker run -d -p 5000:5000 registry "
echo " DONE "
