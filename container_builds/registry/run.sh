#!/bin/bash
#               
# Date:         2014.08.25
# Pupose:       Run an ubuntu 14.04 based docker image as a registry server 
# Author:       Michael Klöckner
# Version:      0.8.0
# 
# We fetcht the docker registry container and configure it for our needs 
#


# Each config option is either set inside the registry config file
# or as a variable to registry start call.
CWD=$(pwd)
CONFIG_FILE="$CWD/config.yml"

# The env variable  DOCKER_REGISTRY_CONFIG  points to the config file 
# /docker-registry/config/config_sample.yml inside the container at 
# We this inject our local file .config.yml into the container.
# But we have to give the absolute path
REGISTRY_CONFIG_OPTION=" -v $CONFIG_FILE:/docker-registry/config/config_sample.yml " 


# The registry port: -p HOST_PORT:CONTAINER_PORTi
REGISTRY_HOST_PORT="5000"
REGISTRY_CONTAINER_PORT="5000"
REGISTRY_PORT_OPTION=" -p $REGISTRY_HOST_PORT=:$REGISTRY_CONTAINER_PORTREGISTRY_CONTAINER_PORT==" 


# AWS S3 options
AWS_BUCKET="im7-registry "
STORAGE_PATH="/registry" 
AWS_KEY="***REMOVED***"
AWS_SECRET="***REMOVED***"
SEARCH_BACKEND="sqlalchemy"

AWS_OPTION=" -e AWS_BUCKET=$AWS_BUCKET -e STORAGE_PATH=$STORAGE_PATH  -e AWS_KEY=$AWS_KEY -e AWS_SECRET=$AWS_SECRET -e SEARCH_BACKEND=$SEARCH_BACKEND "

# The flavor (storage type) as defined in config file.
SETTINGS_FLAVOR="s3"
REGISTRY_SETTINGS_FLAVOR=" -e SETTINGS_FLAVOR=$SETTINGS_FLAVOR"

# Container image to pull:
REGISTRY_IMAGE="registry"

# Container name to start
CONTAINER_NAME="elemica_registry"

# pull the  container form index.docker.io
#docker pull $REGISTRY_IMAGE

# remove the old container
docker kill $CONTAINER_NAME
docker rm   $CONTAINER_NAME

# start a new container
echo docker run --name $CONTAINER_NAME $REGISTRY_SETTINGS_FLAVOR $AWS_OPTION $REGISTRY_CONFIG_OPTION $REGISTRY_IMAGE

