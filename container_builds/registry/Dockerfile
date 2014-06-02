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


## REGISTRY CODE
#add config file
ADD ./config.yml /docker-registry/config/config.yml
ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config.yml
ENV SETTINGS_FLAVOR dev

# add start script
ADD start_script.sh /usr/local/bin/registry_start.sh
#ENTRYPOINT ["/usr/local/bin/registry_start.sh"]
CMD ["/usr/local/bin/registry_start.sh"]

EXPOSE 5000 80


