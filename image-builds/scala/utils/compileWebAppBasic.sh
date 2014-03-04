#!/bin/bash


# we expect a link from local home dir to scala web app 
# this link should be named 'basic'

echo "compiling war file for project basic"
echo ""

cd  /opt/lift_26_sbt-master/scala_210/lift_basic/
./sbt  compile  
./sbt package

echo " EXIT: COMPILED "

