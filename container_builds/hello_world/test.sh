#!/bin/bash
# 
# create a container, that writes hello world, tag it locally and push it into the registry
#

docker build -t registry.im7.de:5000/hello/world:latest .
docker run -i -t  registry.im7.de:5000/hello/world:latest /true
docker push registry.im7.de:5000/hello/world:latest
