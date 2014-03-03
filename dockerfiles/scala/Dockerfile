
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

# create user ubuntu with password '***REMOVED***'
ENV USER_NAME test
ENV USER_PASSWD ***REMOVED***
ENV WEBAPP_BASIC /opt/lift_26_sbt-master/scala_210/lift_basic/
ENV WEBAPP_BLANK /opt/lift_26_sbt-master/scala_210/lift_blanc/

RUN useradd -d /home/$USER_NAME -c "$USER_NAME USER" -m -s /bin/bash -p $(echo "$USER_PASSWD" | openssl passwd -1 -stdin) $USER_NAME


# link the web app dir to ubuntus home dir
RUN ln -s $WEBAPP_BASIC /home/$USER_NAME/basic
RUN ln -s $WEBAPP_BLANK /home/$USER_NAME/blank

# copy compile/deploy scripts to user home dir
ADD utils/compileWebAppBasic.sh /home/$USER_NAME/compileWebAppBasic.sh
ADD utils/compileWebAppBlank.sh /home/$USER_NAME/compileWebAppBlank.sh
ADD utils/deployWebAppBlank.sh /home/$USER_NAME/deployWebAppBlank.sh

RUN chown -R $USER_NAME.$USERNAME /home/$USER_NAME/*
