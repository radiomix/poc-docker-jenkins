#		
# Date:		2014.03.03
# Pupose:	extend the registry container with kdocker web ui
# Author:	Michael Klöckner
# Version:	0.1
#


# use our base image tagged my-registry
FROM my-registry:base

# who we are
MAINTAINER Michael Klöckner <mkl AT im7 DOT de>


# apche2
RUN apt-get install -y apache2
RUN a2enmod proxy_http
RUN a2enmod ssl
RUN a2enmod headers
ADD apache2.registry.conf /etc/apache2/000-default.conf
RUM mkdir /etc/apache2/ssl/
ADD registry.snakeoil.cert /etc/apache2/ssl/registry.cert
ADD registry.snakeoil.key /etc/apache2/ssl/registry.key
RUN mkdir  /etc/apache2/authfiles/
ADD registry.auth /etc/apache2/authfiles/registry
RUN service apache2 restart

## REGISTRY CODE
ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config.yml
ADD ./config.yml /docker-registry/config/config.yml
ENV SETTINGS_FLAVOR dev
ADD ./registry.public.pem /docker-registry/
ENV PRIVILEGED_KEY /docker-registry/registry.public.pem
ENV SQLALCHEMY_INDEX_DATABASE sqlite:////tmp/docker-registry.db
ENV STORAGE_PATH /tmp/


# add start script
ADD start_script.sh /usr/local/bin/registry_start.sh

#ENTRYPOINT can NOT be overridden with `docker run .... /my/command`
#CMD IS overridden by `docker run .... /my/command`
#ENTRYPOINT ["/usr/local/bin/registry_start.sh"]
CMD ["/usr/local/bin/registry_start.sh"]



EXPOSE 5000 80


