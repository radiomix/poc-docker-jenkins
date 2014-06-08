#!/bin/bash

CONT_NAME="nginx"
IMG_NAME="nginx/base_auth"

# delete old container
sudo docker kill $CONT_NAME #&>/dev/null
sudo docker rm $CONT_NAME #&>/dev/null

# build the container and run it
sudo docker build --rm --no-cache -t $IMG_NAME .

echo 
echo
NGINX=$(sudo docker run -d -p 8001:8001 --name $CONT_NAME $IMG_NAME)

echo Running $CONT_NAME PID:$NGINX 
echo "To kill it type :> sudo docker kill $CONT_NAME; sudo docker rm $CONT_NAME"
