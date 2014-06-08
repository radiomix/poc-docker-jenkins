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

# The domain name of the certificate
REG_DOMAIN=registry.im7.de

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
 -p|--pull)
	echo " Pulling Registry "
	sudo docker pull shipyard/docker-registry
	sudo docker tag shipyard/docker-registry $REG_NAME$REG_BASE_TAG 
        ;;
# ----------------------------------------------------------- #
 -c|--config)
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
build.sh -p --pull	pull container shipyard/docker-registry as base and configure it
build.sh -c --config	use the base registry and configure it
build.sh -h --help      this message
      "
  exit
        ;;
esac

echo "Configuring Base Registry "

# create the ssl cert
cd ssl && ./gen_cert.sh $REG_DOMAIN
cd ../

#create the Dockerfile
pwd
cat Dockerfile.base > Dockerfile
echo "ADD ssl/$REG_DOMAIN /opt/ssl/$REG_DOMAIN" >> Dockerfile
echo "ADD ssl/$REG_DOMAIN.cert /opt/ssl/$REG_DOMAIN.cert" >> Dockerfile
more Dockerfile && exit

# build docker registry with nginx
cd ~/docker/poc-docker-jenkins/container_builds/docker-private-registry &&  sudo docker build $BUILD_OPT_MASTER -t $REG_NAME$REG_RUN_TAG  . 

## we are done: 
echo ""
echo ""
echo " WE ARE DONE: "
echo ""
echo "to run REGISTRY as a DOCKER CONTAINER interactively type:"
#echo "docker run -i -t -p 443 -v /registry-storage:/tmp/ -v /path/to/cert_and_key:/opt/ssl -e SSL_CERT_PATH=/opt/ssl/cert.crt -e SSL_CERT_KEY_PATH=/opt/ssl/cert.key $REG_NAME$REG_RUN_TAG"
echo "docker run -i -t -p 443-v /registry-storage:/tmp/ -e SSL_CERT_PATH=/opt/ssl/registry.cert -e SSL_CERT_KEY_PATH=/opt/ssl/registry.key --name $CONT_NAME $REG_NAME$REG_RUN_TAG /usr/local/bin/run.sh"
echo ""
#echo "sudo docker run -i -t -p 443:443 -v /registry-storage:/tmp/ $REG_NAME$REG_RUN_TAG /bin/bash "
#echo " within the container you start the registry app typing: docker-registry"
echo ""
