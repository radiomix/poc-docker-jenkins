#!/bin/bash


# we just configure the base registry
./build.sh -c 

# this is the name of the running container
CONT_NAME=my_registry

docker kill $CONT_NAME
docker rm $CONT_NAME


docker run -i -t -v /registry-storage:/tmp/ -p 5000:5000 --name $CONT_NAME my-registry:run /bin/bash
