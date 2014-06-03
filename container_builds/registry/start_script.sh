#!/bin/bash

#
# This script contains start commands for the docker registry
#

# we need apache for basic authentication
# and proxy to localhost:5000
service apache2 stop
service apache2 start


# the binary docker-registry executable
# maybe we could start the unicorn app like
# in https://github.com/dotcloud/docker-registry
# gunicorn -k gevent --max-requests 100 --graceful-timeout 3600 -t 3600 -b localhost:5000 -w 8 docker_registry.wsgi:application
docker-registry 

