#!/bin/bash

CONT_NAME="nginx_kweb"
IMG_NAME="nginx/kweb"

# delete old container
sudo docker kill $CONT_NAME #&>/dev/null
sudo docker rm $CONT_NAME #&>/dev/null

# test for input parameter
case "$1" in
# ----------------------------------------------------------- #
 -b|--build)
        echo " Building nginx "
# build the container and run it
sudo docker build --rm --no-cache -t $IMG_NAME .
        ;;
# ----------------------------------------------------------- #
 -d|--daemon)
        echo " Running nginx as a daemon"
NGINX=$(sudo docker run -d -p 8001:8001 --name $CONT_NAME $IMG_NAME)
        ;;
# ----------------------------------------------------------- #
 -i|--interactive)
        echo " Running nginx interactively "
sudo docker run -i -t -p 8001:8001 --name $CONT_NAME $IMG_NAME /bin/bash
        ;;
# ----------------------------------------------------------- #
 -h|--help|*)
  echo "
 usage: 
test.sh -i --interactive run container $IMG_NAME interactively
test.sh -d --daemon 	 run container $IMG_NAME as a daemon
test.sh -b --build	 build the container 
test.sh -h --help        this message
      "
  exit
        ;;
esac
