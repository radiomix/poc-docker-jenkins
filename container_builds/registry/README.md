docker registry
=
Build a private registry from [Dotcloud Github Repo](https://github.com/dotcloud/docker-registry)

Prerequest
===
We assume there is a storage device mounted on /registry-storage to the docker host.
This folder is added to the container as the folder tmp  issuing command 
`docker run -v /registry-storage:/tmp/`. 
The registry uses the tmp folder to store the registry data.
build.sh
===
This script builds the registry container either fresh or by pulling samalba/docker-registry.
It then configures the container and tags it my-registry:mkl

Usage
====

```bash
build.sh -b --build     build a fresh base registry container and configure it
build.sh -p --pull      pull container samalba/docker-registry as base and configure it
build.sh -c --configure use the base registry and configure it
build.sh -h --help      this message
```

registry reachability
========

We tested container samalba/docker-registry 

The registry was only reachable within the same AWS availability zone
