# Date:         2014.06.05
# Pupose:       provide basic authentification on docker host with nginx
# Author:       Michael Klöckner
# Source: 	http://rigprog.com/docker-recipes/registry-basic-auth.html
# Version:      0.1
#MKL 2014.06.05 REV_0_7_0

FROM  dockerfile/nginx

# who we are
MAINTAINER Michael Klöckner <mkl AT im7 DOT de>


RUN apt-get install -y unzip

# copy config and auth file
ADD registry.conf /etc/nginx/sites-enabled/registry.conf
ADD registry.auth /etc/nginx/registry.auth
<<<<<<< HEAD
ADD kdocker-web/ /usr/share/nginx/html/
ADD run.sh /usr/local/bin/run.sh
RUN service nginx restart
=======
ADD https://codeload.github.com/tsaikd/kdocker-web/zip/master /usr/share/nginx/html/kdocker-web.zip
RUN cd /usr/share/nginx/html/ && unzip kdocker-web.zip
RUN cd /usr/share/nginx/html/ && mv kdocker-web-master kdocker-web
#RUN service nginx restart
>>>>>>> ddcaddc08843f4ad148b8e6100cd0a4d29d0095d
#RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

#Cleaning up 
RUN rm -f /var/lib/apt/lists/archive*

# Define working directory.
WORKDIR /etc/nginx

<<<<<<< HEAD
=======
# Define default command.
CMD["nginx"]

>>>>>>> ddcaddc08843f4ad148b8e6100cd0a4d29d0095d
# Expose ports.
EXPOSE 8001

# Define default command.
CMD ["/usr/local/bin/run.sh"]


