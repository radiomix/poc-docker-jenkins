docker registry
=
Build a private registry from [Dotcloud Github Repo](https://github.com/dotcloud/docker-registry)

build.sh
===
This script builds the registry container either fresh or by pulling samalba/docker-registry.
It then configures the container and tags it my-registry:mkl

Usage
====

```bash
build.sh -b --build     build a fresh registry container and configure it
build.sh -p --pull      pull container samalba/docker-registry and configure it
build.sh -h --help      this message
```

registry reachability
========

We tested container samalba/docker-registry 

The registry was only reachable within the same AWS availability zone
