
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a ubunut 12.04 based container whith openjdk and tomcat installed
# Author:	Michael Klöckner
# Version:	0.1
#


# use our base image debian/fresh
FROM ubuntu

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

#
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y wget
RUN apt-get install -y zip
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y lynx
RUN apt-get install -y sudo



# insall tomcat
RUN apt-get update
RUN apt-get install -y tomcat7

# install scala/lift web app
RUN wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip
RUN unzip -d /opt/ /tmp/master.zip
RUN rm -f /tmp/maset.zip

