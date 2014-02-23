#
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container whith openjdk7, tomcat7, scala web app installed
# Author:	Michael Klöckner
# Version:	0.3
#


# use our base image debian/fresh
FROM debian/tomcat7:fresh_tomcat7

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

# install scala/lift web app
RUN wget -O /tmp/master.zip https://github.com/Lift/Lift_26_sbt/archive/master.zip
RUN unzip -d /opt/ /tmp/master.zip
RUN rm -f /tmp/maset.zip

# compile the scala/lift web app into a war file once, to download necessery scala/java files
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt package && ./sbt compile

# copy the resulting war file into tomcats web app dir 
RUN cp /opt/lift_26_sbt-master/scala_210/lift_blank/target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war  /var/lib/tomcat7/webapps/lift_blank.war

CMD service tomcat7 start
