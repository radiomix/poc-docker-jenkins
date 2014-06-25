#!/bin/bash
#		Scala/Java/WebApp
# Date:		2014.03.03
# Pupose:	Build a ubunut 12.04 based image as a registry server 
# Author:	Michael Klöckner
# Version:	0.7
# MKL 2014.06.04 REV_0_7_0
# 
# We let docker build a new registry container and tag it $REG_NAME$REG_BASE_TAG
# We then configure it for our needs and tag it $REG_NAME$REG_RUN_TAG
# We don`t use the cache but build from scratch
# We could as well just pull samalba/docker-registry from docker.io
#


# This is how we call the base container
REG_NAME="my-registry"
# This is the tag
REG_BASE_TAG=":base"
REG_RUN_TAG=":run"
# The registry version:  Not all registry version are running smoothly.
REG_VERSION="0.7.0"    

# this is the name of the running container
CONT_NAME=my_registry

# use this to pass docker build options like --no-cache
BUILD_OPT=" --no-cache --rm "
BUILD_OPT_MASTER=" --no-cache --rm "


# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--base)  # we install dependencies on host to speed up container build
	echo " Building Registry Version $REG_VERSION"
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
	sudo rm -rf /docker-registry*
	# download the registry code from github
	sudo git clone https://github.com/dotcloud/docker-registry.git /docker-registry
	#MKL newst version works??? 
	#cd /docker-registry && sudo git checkout $REG_VERSION

	# copy local config file:
	sudo cp ~/docker/poc-docker-jenkins/container_builds/registry/config.yml /docker-registry/config/config.yml

	# install the registry code locally from REG_VERSION
	sudo pip install /docker-registry/depends/docker-registry-cor
	sudo pip install /docker-registry/

	# build a docker image from the REG_VERSION github version and tag it as our base image 
	sudo docker build $BUILD_OPT --rm -t $REG_NAME:$REG_VERSION  /docker-registry/
	sudo docker tag  $REG_NAME:$REG_VERSION $REG_NAME$REG_BASE_TAG   
	sudo docker images 
        ;;
# ----------------------------------------------------------- #
 -p|--pull)
	echo " Pulling Registry "
	sudo docker pull samalba/docker-registry
	sudo docker tag samalba/docker-registry $REG_NAME$REG_BASE_TAG 
        ;;
# ----------------------------------------------------------- #
 -c|--config)
	echo " Configure Registry "
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
build.sh -b --base	build a fresh base registry container and configure it
build.sh -p --pull	pull container samalba/docker-registry as base and configure it
build.sh -c --config	use the base registry and configure it
build.sh -h --help      this message
      "
  exit
        ;;
esac

echo "Configuring Base Registry "
# build docker registry with apache
cd ~/docker/poc-docker-jenkins/container_builds/registry &&  sudo docker build $BUILD_OPT_MASTER -t $REG_NAME$REG_RUN_TAG  . 

## we are done: 
echo ""
echo ""
echo " WE ARE DONE: "
#echo " to run the REGISTRY as a GUNICORN APPLICATION type:"
#echo "sudo gunicorn --access-logfile - --log-level debug --debug -b 0.0.0.0:5000 -w 1 wsgi:application"
echo ""
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER interactively type:"
echo "sudo docker run -i -t -p 5000:5000 -v /registry-storage:/tmp/ $REG_NAME$REG_RUN_TAG /bin/bash "
echo " within the container you start the registry app typing: docker-registry"
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER as a daemon type:"
echo "sudo docker run -d -p 5000:5000 -v /registry-storage:/tmp/ $REG_NAME$REG_RUN_TAG "
echo ""
