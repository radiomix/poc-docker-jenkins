#
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container whith openjdk7, tomcat7 installed
# Author:	Michael Klöckner
# Version:	0.2
#


# use openjdk7 image debian/openjdk7:fresh_openjdk7
FROM debian/openjdk7:fresh_openjdk7

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>


# insall tomcat
RUN apt-get update
RUN apt-get install -y tomcat7
