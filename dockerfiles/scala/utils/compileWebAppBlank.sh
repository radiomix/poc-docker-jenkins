#!/bin/bash


# we expect a link from local home dir to scala web app 
# this link should be named 'blank'

echo "compiling war file for project blank"
echo ""

cd ~/blank
./sbt  compile && ./sbt package

