# Regsitry Basic Auth
Provide basic authentication to a docker registry

## Source
http://rigprog.com/docker-recipes/registry-basic-auth.html

## Install 
We install nginx  version > 1.3.9

    sudo add-apt-repository -y ppa:nginx/stable
    sudo apt-get update
    sudo aptitude install nginx
    # copy config and auth file
    sudo cp registry.conf /etc/nginx/sites-enabled/registry.conf
    sudo cp registry.auth /etc/nginx/registry.auth

    sudo service nginx restart


## Prerequests
To protect the registry we assume it is running on port 5000
Start your registry like:> `docker run -d -p 5000:5000 registry `.

### Docker Options
In order do connect to the docker host, we need to set docker server options, to allow these connections:
`DOCKER_OPTS="-api-enable-cors=true -H tcp://10.0.0.4:4243 -H unix:///var/run/docker.sock"` int `/etc/default/docker`
if 10.0.0.4 is the private ip of the docker host.


## Configuration
`registry.conf` contains the nginx configuration. Please adopt it to your needs.
The container build with this Dockerfile runs nginx on port 8001.

`registry.auth` is a password file build with `htpasswd -c registry.auth USERNAME`


