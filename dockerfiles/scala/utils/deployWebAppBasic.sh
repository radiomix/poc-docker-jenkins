#!/bin/bash


# we expect a link from local home dir to scala web app 
# this link should be named 'basic'
# we also expect the web app to be called basic.war

echo ""
echo "deploying war file for project basic"
echo ""


echo "deleting old war file "
cd ~/basic/target/scala-2.10/
rm -f *war

echo "get newest source from git repo"
cd ~/basic/src
git pull

echo "compile new war file"
cd ~/basic
./sbt  compile && ./sbt package


echo "deploying war file to tomcat7 webapp dir: /var/lib/tomcat7/webapps/ "
sudo service tomcat7 stop
cd ~/basic/target/scala-2.10/
ls -l *war

echo "removing previous web app"
sudo rm -rf /var/lib/tomcat7/webapps/basic*

echo "copying new web app"
sudo cp  *war /var/lib/tomcat7/webapps/basic.war
sudo chown tomcat7.tomcat7 *war
sudo service tomcat7 start
ls -l /var/lib/tomcat7/webapps/

