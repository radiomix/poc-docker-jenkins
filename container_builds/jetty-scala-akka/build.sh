#!/bin/bash
# Scala/Java/WebApp running in an  ubuntu:14.04 docker container
#
# MAINTAINER Michael Klöckner <mkl AT im7 DOT de>

# lazy of typing the same stuff:
APT_INST="apt-get install -y --no-install-recommends"
CWD=$(pwd)

echo " INSTALLING UTILS "
sudo apt-get update
sudo $APT_INST apt-utils

sudo $APT_INST wget
sudo $APT_INST zip
sudo $APT_INST git
sudo $APT_INST unzip
sudo $APT_INST openjdk-7-jdk

echo " INSTALLING SCALA and SBT "
sudo $APT_INST scala
wget -O /tmp/sbt-0.13.5.deb http://dl.bintray.com/sbt/debian/sbt-0.13.5.deb
sudo dpkg -i /tmp/sbt-0.13.5.deb


#####################################
echo " INSTALLING SCALA/LIFT EXAMPLE "
export WEBAPP_HELLO="/opt/hello/"
export WEBAPP_HELLO_JAR=$WEBAPP_HELLO/target/scala-2.10/
#wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip 
sudo mkdir $WEBAPP_HELLO &> /dev/null
sudo chown -R ubuntu $WEBAPP_HELLO

cd $WEBAPP_HELLO/
echo 'object Hi { def main(args: Array[String]) = println("Hi!") }' > hw.scala
# create a rudimentary build.sbt file
touch $WEBAPP_HELLO/build.sbt 
cat << EOF > $WEBAPP_HELLO/build.sbt 
name := "hello"

version := "1.0"

scalaVersion := "2.10.3"

EOF

sbt compile
sbt package

cd $CWD
echo "BUILDING NEW JETTY CONTAINER in $(pwd)"
JETTY_NAME="jetty/jetty-demo:example"
CONTAINER_NAME="jetty_scala"
#sudo docker rmi $JETTY_NAME  &> /dev/null           # remove old build artefact
sudo docker build --rm  -t $JETTY_NAME .             # rebuild new image

export WEBAPPS=/opt/jetty/webapps
sudo mkdir -p $ WEBAPPS &>/dev/null
sudo chown -R ubuntu $ WEBAPPS

ls  $WEBAPP_HELLO_JAR

#kill/remove old container and run the new one
sudo docker kill $CONTAINER_NAME &>/dev/null  
sudo docker rm $CONTAINER_NAME &>/dev/null
JETTY=$(docker run -d --name=$CONTAINER_NAME -p 80:8080 -v $WEBAPPS:/opt/jetty/webapps jetty/jetty-demo:example)
cp $WEBAPP_HELLO_JAR/*jar $WEBAPPS

echo "
#############################
# deploy the jar file to a directory, 
# that is read by a docker container running jetty
#    WEBAPPS=$WEBAPPS
#    docker run -p 80:8080 -v \$WEBAPPS:/opt/jetty/webapps jetty/jetty-demo &
# Then to hot-deploy web apps:
#     cp something.war \$WEBAPPS
# http://localhost lists currently running apps
#############################
"

