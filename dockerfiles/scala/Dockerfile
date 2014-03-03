
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
ENV APT_INST apt-get install -y --no-install-recommends
#
RUN apt-get update
RUN $APT_INST apt-utils

RUN $APT_INST apt-utils
RUN $APT_INST wget
RUN $APT_INST zip
RUN $APT_INST git
RUN $APT_INST vim
RUN $APT_INST lynx
RUN $APT_INST sudo
RUN $APT_INST unzip


# insall tomcat
RUN $APT_INST --no-install-recommends tomcat7

# install scala/lift web app
RUN wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip 
RUN unzip -d /opt/ /tmp/master.zip
RUN rm -f /tmp/master.zip

# create user ubuntu with password '***REMOVED***'
ENV USER_NAME ubuntu
ENV USER_PASSWD ***REMOVED***
ENV WEBAPP_BASIC /opt/lift_26_sbt-master/scala_210/lift_basic/
ENV WEBAPP_BLANK /opt/lift_26_sbt-master/scala_210/lift_blank/

RUN useradd -d /home/$USER_NAME -c "$USER_NAME USER" -m -s /bin/bash -p $(echo "$USER_PASSWD" | openssl passwd -1 -stdin) $USER_NAME


# link the web app dir to ubuntus home dir
RUN ln -s $WEBAPP_BASIC /home/$USER_NAME/basic
RUN ln -s $WEBAPP_BLANK /home/$USER_NAME/blank

# copy compile/deploy scripts to user home dir
ADD utils/compileWebAppBasic.sh /home/$USER_NAME/compileWebAppBasic.sh
ADD utils/compileWebAppBlank.sh /home/$USER_NAME/compileWebAppBlank.sh
ADD utils/deployWebAppBlank.sh /home/$USER_NAME/deployWebAppBlank.sh

RUN chown -R $USER_NAME.$USERNAME /home/$USER_NAME/*
