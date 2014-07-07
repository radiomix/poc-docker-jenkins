#!/bin/bash
# Scala/Java/WebApp running in an  ubuntu:14.04 docker container
#
# MAINTAINER Michael Klöckner <mkl AT im7 DOT de>

# lazy of typing the same stuff:
APT_INST="apt-get install -y --no-install-recommends"
CWD=$(pwd)

echo " INSTALLING UTILS "
echo "
sudo apt-get update
sudo $APT_INST apt-utils

sudo $APT_INST wget
sudo $APT_INST zip
sudo $APT_INST git
sudo $APT_INST unzip
sudo $APT_INST openjdk-7-jdk
FIXME FIXME in $0 FIXME FIXME FIXME in $0 
"
#####################################
echo " INSTALLING SCALA and SBT "
sudo $APT_INST scala
wget -O /tmp/sbt-0.13.5.deb http://dl.bintray.com/sbt/debian/sbt-0.13.5.deb
sudo dpkg -i /tmp/sbt-0.13.5.deb

#####################################
echo " INSTALLING TYPESAFE AKKA "
sudo mkdir /opt/typesafe &> /dev/null
sudo chown -R ubuntu /opt/typesafe &>/dev/null 
if [ -s /tmp/typesafe-activator-1.2.3.zip ]
 then 
 echo " Skipping download activator file" 
 else 
   wget -O /tmp/typesafe-activator-1.2.3.zip http://downloads.typesafe.com/typesafe-activator/1.2.3/typesafe-activator-1.2.3.zip
 echo "Typesafe Activator downloaded!"
fi

unzip -o -qq -d /opt/typesafe  /tmp/typesafe-activator-1.2.3.zip 
export TYPESAFE="/opt/typesafe/activator-1.2.3/"

#####################################
export WEBAPP_AKKA="activator-akka-tracing"		#this is the sample app
echo " INSTALLING SCALA/LIFT EXAMPLE $WEBAPP_AKKA"
export WEBAPP_AKKA_JAR=$WEBAPP_AKKA/target/scala-2.11/
cd $TYPESAFE
rm -rf $WEBAPP_AKKA &>/dev/null
# create the web app with akka:> ./activator new PROJECTNAME activator-akka-tracing
./activator new $WEBAPP_AKKA $WEBAPP_AKKA             


#
#prepare to package the war file

echo " Preparing to build a WAR file "
cd $TYPESAFE$WEBAPP_AKKA

sbt compile
sbt package


# copy jar file into the jetty directory
export WEBAPPS=/opt/jetty/webapps
sudo mkdir -p $ WEBAPPS &>/dev/null
cp $TYPESAFE$WEBAPP_AKKA_JAR/*jar $WEBAPPS
sudo chown -R ubuntu $ WEBAPPS
ls  $WEBAPPS


#####################################
cd $CWD
echo "BUILDING NEW JETTY CONTAINER in $(pwd)"
JETTY_NAME="jetty/jetty-demo:example"
CONTAINER_NAME="jetty_scala"
#sudo docker rmi $JETTY_NAME  &> /dev/null           # remove old build artefact
sudo docker build --rm  -t $JETTY_NAME .             # rebuild new image



#kill/remove old container and run the new one
sudo docker kill $CONTAINER_NAME &>/dev/null  
sudo docker rm $CONTAINER_NAME &>/dev/null
JETTY=$(docker run -d --name=$CONTAINER_NAME -p 80:8080 -v $WEBAPPS:/opt/jetty/webapps jetty/jetty-demo:example)


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

