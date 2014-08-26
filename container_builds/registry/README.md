### Description of the registry:
The registry is based on [registry github](http://github.com/docker/docker-registry/).
### Configuration
We just provide a local [`confgi.yml`](config.yml) for commodity reasons. This file can be tweaked.

### Start script
We use script [`start_registry.sh`](start_registry.sh) to set some environment variables 
(espacially AWS options) and start the container.

### Notes
The registry wont accept env variable `AWS_REGION` in start up command as stated by [issue 400](https://github.com/docker/docker-registry/issues/400).

