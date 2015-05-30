#!/bin/bash


# we expect a link from local home dir to scala web app 
# this link should be named 'blank'

echo "compiling war file for project blank"
echo ""

cd  /opt/lift_26_sbt-master/scala_210/lift_blank/
./sbt  compile 
./sbt package

echo "EXIT COMPILED "
