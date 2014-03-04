#		
# Date:		2014.03.03
# Pupose:	extend the registry container with kdocker web ui
# Author:	Michael Klöckner
# Version:	0.1
#


# use our base image tagged my-registry
FROM my-registry

# who we are
MAINTAINER Michael Klöckner <mkl@im7.de>

#
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y sudo
RUN apt-get install -y unzip


# create user ubuntu with password '***REMOVED***'
ENV USER_NAME test
ENV USER_PASSWD ***REMOVED***
RUN useradd -d /home/$USER_NAME -c "$USER_NAME USER" -m -s /bin/bash -p $(echo "$USER_PASSWD" | openssl passwd -1 -stdin) $USER_NAME

ADD ubuntu /etc/sudoers.d/90-ubuntu
RUN chown root.root /etc/sudoers.d/90-ubuntu
RUN chmod 440  /etc/sudoers.d/90-ubuntu

RUN wget -O /tmp/kdocker.zip https://github.com/tsaikd/kdocker-web/archive/master.zip 
RUN unzip -d /var/www/ /tmp/kdocker.zip
RUN mv /var/www/kdocker-web-master/ /var/www/docker/
RUN chown -R www-data.www-data /var/www/
ADD .htpasswd /var/www/docker/.htpasswd
ADD .htaccess /var/www/docker/.htaccess
RUN service apache2 start

