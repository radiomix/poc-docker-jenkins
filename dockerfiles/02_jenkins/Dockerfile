#
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container whith openjdk7, jenkins installed, configure jenkins to run on port 8090
# Author:	Michael Klöckner
# Version:	0.2
#


# use openjdk7 image debian/openjdk7:fresh_openjdk7
FROM debian/openjdk7:fresh_openjdk7

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>


# add jenkins server to repo list
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key sudo | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update

# install netstat, needed by jenkins
RUN apt-get install -y net-tools

# insall jenkins
RUN apt-get install -y jenkins
RUN sed -i s/HTTP_PORT=8080/HTTP_PORT=8090/ /etc/default/jenkins
RUN service jenkins stop
RUN service jenkins start
