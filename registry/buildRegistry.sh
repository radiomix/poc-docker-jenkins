#!/bin/bash
#		Scala/Java/WebApp
# Date:		2014.03.03
# Pupose:	Build a ubunut 12.04 based image as a registry server 
# Author:	Michael Klöckner
# Version:	0.3
#


# dependencies
sudo apt-get update
sudo apt-get install -y apt-utils
sudo apt-get install -y wget
sudo apt-get install -y zip
sudo apt-get install -y git
sudo apt-get install -y vim
sudo apt-get install -y lynx
sudo apt-get install -y sudo
sudo apt-get install -y gcc




# install python-pip
sudo apt-get update
sudo apt-get install -y python
sudo apt-get install -y python-pip

# update pip
sudo wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O /tmp/get-pip.py
sudo python /tmp/get-pip.py
sudo rm /tmp/get-pip.py


# install deb-packages from docker-registry/Dockerfile
sudo apt-get install -y git-core build-essential python-dev libevent-dev python-openssl liblzma-dev

# clean up previous github downloads
sudo rm -rf /tmp/docker-registry* 
# download the registry code from github and build
sudo git clone https://github.com/dotcloud/docker-registry.git /tmp/docker-registry

# build a gunicorn app:
cd /tmp/docker-registry; sudo  cp config/config_sample.yml config/config.yml
cd /tmp/docker-registry; sudo pip install -r requirements.txt


# or build a docker image
sudo cd docker-registry; sudo docker build -rm -t my-registry . 
sudo docker images 

## we are ready: 
echo ""
echo ""
echo " WE ARE DONE: "
echo " to run the REGISTRY as a GUNICORN APPLICATION type:"
echo "sudo gunicorn --access-logfile - --log-level debug --debug -b 0.0.0.0:5000 -w 1 wsgi:application"
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER interactively type:"
echo "sudo docker run -i -t -p 5000:5000 my-registry /bin/bash "
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER as a daemon type:"
echo "sudo docker run -d -p 5000:5000 my-registry "
echo ""
