#!/bin/bash
#		
# Date:		2014.06.25
# Pupose:	Build a ubunut 12.04 based image as a registry server 
# Author:	Michael Klöckner
# Version:	0.7
# MKL 2014.06.04 REV_0_7_3
# 
# We let docker build a new registry container and tag it $REG_NAME$REG_BASE_TAG
# We then configure it for our needs and tag it $REG_NAME$REG_RUN_TAG
# We don`t use the cache but build from scratch
# We could as well just pull samalba/docker-registry from docker.io
#


# This is how we call the base container
REG_NAME=${REG_NAME:-elemica-registry}

# This is the tag
REG_BASE_TAG=":base"
REG_RUN_TAG=":run"
# The registry version:  Not all registry version are running smoothly.
REG_VERSION="0.7.3"    
#REG_VERSION="0.8.0"    

# registry storage directory
REG_STORE_DIR="/mnt/registry-storage/"

# this is the name of the running container
CONT_NAME=elemica_registry

# use this to pass docker build options like --no-cache
BUILD_OPT=" --no-cache --rm "
BUILD_OPT_MASTER=" --no-cache --rm "

#rsa key length
DEF_KEY_LENGTH=2048
RSA_KEY_LENGTH=${RSA_KEY_LENGTH:-$DEF_KEY_LENGTH}

# AWS S3 Bucket and Storage path
AWS_BUCKET="docker-registry-router-oregon-stg"
STORAGE_PATH=/test

# registry flavor
SETTINGS_FLAVOR=s3

############################################
# configuration done
############################################

# chedk input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--base)  
	echo " Building Base Registry Version $REG_VERSION"

	# clean up previous github downloads
	sudo rm -rf /docker-registry*
	# download the registry code from github
	sudo git clone https://github.com/dotcloud/docker-registry.git /docker-registry
	#MKL newst version works??? 
	cd /docker-registry && sudo git checkout $REG_VERSION

	# copy local config file:
	sudo cp -v ~/poc-docker-jenkins/container_builds/registry/config.yml /docker-registry/config/config.yml

	# install the registry code locally from REG_VERSION
	#sudo pip install /docker-registry/depends/docker-registry-cor
	#sudo pip install /docker-registry/

	# build a docker image from the REG_VERSION github version and tag it as our base image 
	sudo docker build $BUILD_OPT -t $REG_NAME:$REG_VERSION  /docker-registry/
	sudo docker tag  $REG_NAME:$REG_VERSION $REG_NAME$REG_BASE_TAG   
	sudo docker images 
	exit
        ;;
# ----------------------------------------------------------- #
 -p|--pull)
	echo " Pulling Registry "
	sudo docker pull samalba/docker-registry
	sudo docker tag samalba/docker-registry $REG_NAME$REG_BASE_TAG 
	sudo docker images
	exit
        ;;
# ----------------------------------------------------------- #
 -r|--run)
####FIXME check if we are called as root to enshure proper rights for REG_STORE_DIR
#        if [ ! -d "$REG_STORE_DIR" ] 
#	then 
#          echo "ERROR: Directory $REG_STORE_DIR does not exist"
#          exit 100
#        fi
#        if [ ! -r "$REG_STORE_DIR" ] 
#	then 
#          echo "ERROR: Directory $REG_STORE_DIR not readable"
#          exit 100
#        fi
#        if [ ! -w "$REG_STORE_DIR" ] 
#	then 
#          echo "ERROR: Directory $REG_STORE_DIR not writeable"
#          exit 100
#        fi
	echo " Running Registry "
#	sudo docker run -d --name="$CONT_NAME" -p 5000:5000 -v $REG_STORE_DIR:/tmp/ \
	sudo docker run -d --name="$CONT_NAME" -p 5000:5000 -v $REG_STORE_DIR:/tmp/ \
		-e AWS_BUCKET=$AWS_BUCKET -e STORAGE_PATH=$STORAGE_PATH -e SETTINGS_FLAVOR=$SETTINGS_FLAVOR \
		$REG_NAME$REG_RUN_TAG 
	sudo docker ps -a | grep $CONT_NAME 
	exit
        ;;
# ----------------------------------------------------------- #
 -h|--help)
  echo "
 usage: 
build.sh -b --base	build a fresh base registry container and configure it
build.sh -p --pull	pull container samalba/docker-registry as base and configure it
build.sh -c --config	use the local base registry and configure it
build.sh -r --run	run registry as a container
build.sh -h --help      this message
      "
	exit
        ;;
# ----------------------------------------------------------- #
 -c|--config) 
	echo " Configuring Registry "

# install python-pip
echo " Installing python packages and openssl"
sudo apt-get update
sudo apt-get install -y python
sudo apt-get install -y python-pip
# we need to install python-rsa-package to convert openssl key to python library key
sudo pip install rsa
sudo apt-get install -y openssl

#generata public key
echo " Generating registry permission file "
openssl genrsa  -out private.pem $RSA_KEY_LENGTH
#associate public key
pyrsa-priv2pub -i private.pem -o public.pem

echo "Deleting old Registry "
# delete docker registry 
sudo docker rmi  $REG_NAME$REG_RUN_TAG   

echo "Configuring Base Registry "
# configure docker registry 
cd ~/poc-docker-jenkins/container_builds/registry &&  sudo docker build $BUILD_OPT_MASTER -t $REG_NAME$REG_RUN_TAG  . 

## we are done: 
echo ""
echo " WE ARE DONE: "
#echo " to run the REGISTRY as a GUNICORN APPLICATION type:"
#echo "sudo gunicorn --access-logfile - --log-level debug --debug -b 0.0.0.0:5000 -w 1 wsgi:application"
echo ""
echo "Make shure directory /registry-storage exists on host!"
echo "to run REGISTRY as a DOCKER CONTAINER as a daemon called $CONT_NAME type:"
echo "
	sudo docker run -d --name="$CONT_NAME" -p 5000:5000 -v $REG_STORE_DIR:/tmp/ \
		-e AWS_BUCKET=$AWS_BUCKET -e STORAGE_PATH=$STORAGE_PATH -e SETTINGS_FLAVOR=$SETTINGS_FLAVOR \
		$REG_NAME$REG_RUN_TAG "
echo "Or symply type ./build.sh -r"
echo ""

echo " FINISHED "
docker images 
exit
        ;;
# ----------------------------------------------------------- #
  *)  $0 -h ;;   ## show help message
esac
# ----------------------------------------------------------- #
exit
