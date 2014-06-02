#!/bin/bash
#		Scala/Java/WebApp
# Date:		2014.03.03
# Pupose:	Build a ubunut 12.04 based image as a registry server 
# Author:	Michael Klöckner
# Version:	0.7
# 
# We let docker build a new registry container and tag it my-registry:base
# We could as well just pull samalba/docker-registry from docker.io
#




# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--build)  # we install dependencies on host to speed up container build
	echo " Building Registry "
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

	# install deps for backports.lzma (python2 requires it)
	sudo apt-get -y install python-dev liblzma-dev libevent1-dev
#####################################
# All we need for the registry is 
# installed on this host, saving time
# to build the container
#####################################

	# clean up previous github downloads
	sudo rm -rf /tmp/docker-registry*
	# download the registry code from github
	sudo git clone https://github.com/dotcloud/docker-registry.git /tmp/docker-registry
	# copy local config file:
	cd /tmp/docker-registry; sudo  cp ~/docker/poc-docker-jenkins/container_builds/registry/config.yml config/config.yml

	# build a docker image
	sudo cd /tmp/docker-registry; sudo docker build -rm -t my-registry:base . 
	sudo docker images 


        ;;
# ----------------------------------------------------------- #
 -p|--pull)
	echo " Pulling Registry "
	sudo docker pull samalba/docker-registry
	sudo docker tag samalba/docker-registry my-registry:base
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
build.sh -b --build  	build a fresh registry container and configure it
build.sh -p --pull	pull container samalba/docker-registry and configure it
build.sh -h --help      this message
      "
  exit
        ;;
esac


# build docker registry with apache
sudo docker build -t my-registry:mkl . 

## we are done: 
echo ""
echo ""
echo " WE ARE DONE: "
#echo " to run the REGISTRY as a GUNICORN APPLICATION type:"
#echo "sudo gunicorn --access-logfile - --log-level debug --debug -b 0.0.0.0:5000 -w 1 wsgi:application"
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER interactively type:"
echo "sudo docker run -i -t -p 5000:5000 my-registry:mkl /bin/bash "
echo " within the container you start the registry app typing: docker-registry"
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER as a daemon type:"
echo "sudo docker run -d -p 5000:5000 my-registry:mkl "
echo ""
