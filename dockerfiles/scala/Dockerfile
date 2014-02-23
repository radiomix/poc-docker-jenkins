
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container whith openjdk installed
# Author:	Michael Klöckner
# Version:	0.1
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
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y lynx


# insall tomcat
RUN apt-get update
RUN apt-get install -y tomcat7

# install scala/lift web app
RUN wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip
RUN unzip -d /opt/ /tmp/master.zip
RUN rm -f /tmp/maset.zip

# compile the scala/lift web app into a war file once, to download necessery scala/java files
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt compile && ./sbt package 

# clean up previous compiles
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt clean
# compile
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt compile
# compile and package the scala/lift web app into a war file
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt package 

# delete the old web app jar file
RUN m -rf   /var/lib/tomcat7/webapps/test*
# copy the resulting war file into tomcats web app dir as file 'test.war'
RUN  cd /opt/lift_26_sbt-master/scala_210/lift_blank/ &&  cp target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war  /var/lib/tomcat7/webapps/test.war

# restart service tomcat7, not realy necessary, but nice and clean
RUN service  tomcat7 restart
