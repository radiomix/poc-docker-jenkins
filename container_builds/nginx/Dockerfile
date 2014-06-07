# Date:         2014.06.05
# Pupose:       provide basic authentification on docker host with nginx
# Author:       Michael Klöckner
# Source: 	http://rigprog.com/docker-recipes/registry-basic-auth.html
# Version:      0.1
#MKL 2014.06.05 REV_0_7_0

FROM ubuntu:12.04

# who we are
MAINTAINER Michael Klöckner <mkl AT im7 DOT de>


RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu precise main" > /etc/apt/sources.list.d/nginx-stable-precise.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C


# install nginx  version > 1.3.9
RUN apt-get update
RUN apt-get install -y nginx

# copy config and auth file
ADD registry.conf /etc/nginx/sites-enabled/registry.conf
ADD registry.auth /etc/nginx/registry.auth
ADD kdocker-web/ /usr/share/nginx/html/
ADD run.sh /usr/local/bin/run.sh
RUN service nginx restart
#RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

#Cleaning up 
RUN rm -f /var/lib/apt/lists/archive*

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 8001

# Define default command.
CMD ["/usr/local/bin/run.sh"]


