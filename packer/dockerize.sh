#!/bin/bash
echo '# Load dockerize automatically ' >> /home/ubuntu/.bashrc 
echo 'eval "$(/home/ubuntu/docker/dockerize/bin/dockerize init -)" '  >> /home/ubuntu/.bashrc
echo " " >> /home/ubuntu/.bashrc

