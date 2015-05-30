#!/bin/bash

# this is the name of the running container
CONT_NAME=my_registry



case "$1" in
# ----------------------------------------------------------- #
 -b|--base)
TAG_NAME=base

        ;;
# ----------------------------------------------------------- #
 -c|--configured)
TAG_NAME=run

        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
test.sh -b --base      run the base container 
test.sh -c --config    run the configured continer
test.sh -h --help      this message
      "
exit
        ;;
esac
# ----------------------------------------------------------- #

#cleaning up old container
docker kill $CONT_NAME
docker rm $CONT_NAME


echo docker run -i -t -v /registry-storage:/tmp/ -p 5000:5000 --name $CONT_NAME my-registry:$TAG_NAME docker-registry
docker run -i -t -v /registry-storage:/tmp/ -p 5000:5000 --name $CONT_NAME my-registry:$TAG_NAME docker-registry
