docker registry
========

Build a private registry from [Dotcloud Github Repo](https://github.com/dotcloud/docker-registry)


Docker Version
========

We tested container samalba/docker-registry on two different docker version:
Host0.10.0 with docker version 0.10.0 and Host0.11.1 with docker version 0.11.1 
These are the results.

Host0.10.0  was able to push and pull container images locally and from Host0.11.1.
Host0.11.1 was only able to push and pull container images locally, NOT from other hosts,
neither with docker version 0.10.0 nor 0.11.1 

