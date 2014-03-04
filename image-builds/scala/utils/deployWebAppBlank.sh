#!/bin/bash


# we expect a link from local home dir to scala web app 
# this link should be named 'blank'
# we also expect the web app to be called blank.war

echo ""
echo "deploying war file for project blank"
echo ""


echo "deleting old war file "
cd ~/blank/target/scala-2.10/
rm -f *war

echo "get newest source from git repo"
cd ~/blank/src
git pull

echo "compile new war file"
cd ~/blank
./sbt  compile && ./sbt package


echo "deploying war file to tomcat7 webapp dir: /var/lib/tomcat7/webapps/ "
sudo service tomcat7 stop
cd ~/blank/target/scala-2.10/
ls -l *war

echo "removing previous web app"
sudo rm -rf /var/lib/tomcat7/webapps/blank*

echo "copying new web app"
sudo cp  *war /var/lib/tomcat7/webapps/blank.war
sudo chown tomcat7.tomcat7 *war
sudo service tomcat7 start
ls -l /var/lib/tomcat7/webapps/

