#
#		Scala/Java/WebApp
# Date:		2014.02.21
# Pupose:	Build a debian based container and copy the Scala WebApp WAR-file into tomcat7 web app dir.
# Author:	Michael Klöckner
# Version:	0.4
# 
# Server:	http://localhost:8080/lift_blank


# use our base image debian/fresh
FROM debian/scala:fresh_scala

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

# compile the scala/lift web app into a war file
RUN cd /opt/lift_26_sbt-master/scala_210/lift_blank/ && ./sbt package && ./sbt compile

# copy the resulting war file into tomcats web app dir 
RUN cp /opt/lift_26_sbt-master/scala_210/lift_blank/target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war  /var/lib/tomcat7/webapps/lift_blank

# restart service tomcat7, not realy necessary, but nice and clean
CMD service  tomcat7 restart
