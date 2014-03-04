
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a ubunut 12.04 based container whith openjdk and tomcat installed
# Author:	Michael Klöckner
# Version:	0.1
#



# pull the base image off the registry
FROM registry.im7.de:5000/ubuntu/12.04

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

# lazy of typing the same stuff:
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
RUN $APT_INST tomcat7

# install scala/lift web app
ENV WEBAPP_BASIC /opt/lift_26_sbt-master/scala_210/lift_basic
ENV WEBAPP_BLANK /opt/lift_26_sbt-master/scala_210/lift_blank


RUN wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip 
RUN unzip -d /opt/ /tmp/master.zip
RUN rm -f /tmp/master.zip

# create user ubuntu with password '***REMOVED***'
#ENV USER_NAME ubuntu
#ENV USER_PASSWD ***REMOVED***
#RUN useradd -d /home/$USER_NAME -c "$USER_NAME USER" -m -s /bin/bash -p $(echo "$USER_PASSWD" | openssl passwd -1 -stdin) $USER_NAME

#####################################
#
# STARTING DEPLOYMENT NOW !!!
#
# BETTER SPLITT DOCKERFILE HERE 
# TAG UPPER PART AS IMAGE FOO 
# AND UNCOMMENT NEXT LINES 
#
#FROM FOO
# who we are
#MAINTAINER Michael Klöckner <mkl@im7.de>
#####################################

# remove old web app source 
RUN rm -rf $WEBAPP_BASIC/src*
RUN rm -rf $WEBAPP_BLANK/src*

# git clone the repo
ENV  GIT_BLANK https://github.com/radiomix/scala-blank.git
ENV  GIT_BASIC https://github.com/radiomix/scala-basic.git
RUN git clone $GIT_BASIC $WEBAPP_BASIC/src
RUN git clone $GIT_BLANK $WEBAPP_BLANK/src

# compile new web app source 
RUN cd $WEBAPP_BASIC/ && ./sbt compile
RUN cd $WEBAPP_BLANK && ./sbt compile

# package new web app source 
RUN cd $WEBAPP_BASIC/ && ./sbt package
RUN cd $WEBAPP_BLANK/ && ./sbt package

# remove old web app code
RUN service tomcat7 stop
RUN rm -rf /var/lib/tomcat7/webapps/blank*
RUN rm -rf /var/lib/tomcat7/webapps/basic*

# deploy the two apps
RUN cp $WEBAPP_BASIC/target/scala-2.10/*war /var/lib/tomcat7/webapps/basic.war
RUN cp $WEBAPP_BLANK/target/scala-2.10/*war /var/lib/tomcat7/webapps/blank.war

# start tomcat7 TWO times
RUN service tomcat7 start
RUN service tomcat7 restart
CMD service tomcat7 start
