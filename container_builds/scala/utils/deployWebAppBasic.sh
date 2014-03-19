#!/bin/bash


# we expect the web app to be called basic.war

echo ""
echo "deploying war file for project basic"
echo ""


echo "deleting old war file "
rm -f /opt/lift_26_sbt-master/scala_210/lift_basic/target/scala-2.10/*war

echo "get newest source from git repo"
cd /opt/lift_26_sbt-master/scala_210/lift_basic/
rm -rf src
git clone https://github.com/radiomix/scala-basic.git scr

echo "compile new war file"
cd /opt/lift_26_sbt-master/scala_210/lift_basic
./sbt  compile && ./sbt package


echo "deploying war file to tomcat7 webapp dir: /var/lib/tomcat7/webapps/ "
service tomcat7 stop
echo "removing previous web app"
rm -rf /var/lib/tomcat7/webapps/basic*
cd /opt/lift_26_sbt-master/scala_210/lift_basic/target/scala-2.10/

echo "copying new web app"
cp  *war /var/lib/tomcat7/webapps/basic.war
chown tomcat7.tomcat7 *war
service tomcat7 start
ls -l /var/lib/tomcat7/webapps/

