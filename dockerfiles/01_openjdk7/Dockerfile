
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

