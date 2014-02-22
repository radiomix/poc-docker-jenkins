#
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container whith openjdk7, tomcat7, scala web app installed
# Author:	Michael Klöckner
# Version:	0.3
#


# use our base image debian/fresh
FROM debian:fresh

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

#
RUN apt-get update
RUN apt-get install -y apt-utils

# We need jdk at least version 6, wegt zip :
RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y openjdk-7-jdk
RUN apt-get install -y wget
RUN apt-get install -y zip


# insall tomcat
RUN apt-get install -y tomcat7


# install scala/lift web app
RUN cd /opt
RUN wget https://github.com/Lift/Lift_26_sbt/archive/master.zip
RUN unzip master.zip

