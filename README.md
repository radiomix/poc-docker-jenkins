                             docker.docu
                             ===========

Author: Michael Klöckner
Date: 2014-02-19 21:03:04 CET

1 Overview 
-----------

1.1 Purpose 
============
This paper documents the Proof of Concept Project:
*Enable a Jenkins build server to publish release artifacts as Docker images to a Docker registry. Start
service on a new EC2 node by fetching the artifact from the registry.*

1.2 Author 
===========
 - Author: Michael Klöckner, Weberstr. 39, 60318 Frankfurt am Main, 
 - Email:mkl@im7.de
 - Phone: +49 69 9866 1103

2 Installing docker 
--------------------
This installation guide is take from the [Docker documentation].

[Docker documentation]: http://docs.docer.io/en/latest/

2.1 Kernel options 
===================
Docker needs a 64-Bit Linux distribution, a recent kernel > 3.8 and LXC
installed. Either you use a system with the appropriate kernel installed, or
you update the kernel by hand as described in kernel compilation. The ker-
nel needs to have compiled all options concerning virtual NICs, especially
BRIDGED NICs, all NAT options and all net  ( NF ) options. Download
the kernel source, untar it, change into the directory and configure it prop-
erly. To compile the kernel as a debian package named *fora-kernel-3.13.3*
to be installed later together with it's header follow these instructions:


  make-kpkg clean
  make-kpkg --append-to-version "-flora-kernel-3.13.3" --revision "1" \
  --initrd kernel_image kernel_headers

The package is to be found one directory upwards and can be installed using


  dpkg -i ../linux-headers-3.13.3-flora-kernel-3.13.3_1.2_amd64.deb \
  ../linux-image-3.13.3-flora-kernel-3.13.3_1.2_amd64.deb/.


2.1.2 Installation Script 
==========================
Docker.io provides an installation script to be called: =curl -s https://get.docker.io/ubuntu/ | sudo sh=
Now verify that the installation has worked by downloading the ubuntu
image and launching a container. =sudo docker run -i -t ubuntu /bin/bash=
Type exit to exit.

2.2 Play with docker 
=====================

2.2.1 Check your Docker installation. 
======================================


  # Check that you have a working install
  docker info

2.2.2 Download a pre-built image 
=================================


  # Download an ubuntu image
  sudo docker pull ubuntu

2.2.3 Run an interactive shell 
===============================


  # Run an interactive shell in the ubuntu image,
  # allocate a tty, attach stdin and stdout
  # To detach the tty without exiting the shell,
  # use the escape sequence Ctrl-p + Ctrl-q
  sudo docker run -i -t ubuntu /bin/bash

2.2.4 Bind to a port 
=====================
The Docker client can use -H to connect to a custom port.
-H accepts host and port assignment in the following format: 
- tcp://[host][:port]  =
- unix://path =
- host[:port] or :port =



  # Run docker in daemon mode
  sudo <path to>/docker -H 0.0.0.0:5555 -d &
  # Download an ubuntu image
  sudo docker -H :5555 pull ubuntu

2.2.5 Starting a long run 
==========================


  # Start a very useful long-running process
  JOB=$(sudo docker run -d ubuntu /bin/sh -c "while true; \
  do echo Hello world; sleep 1; done")
  # Collect the output of the job so far
  sudo docker logs $JOB
  # Kill the job
  sudo docker kill $JOB


2.3 Build your own base image 
==============================
Docker.io provides a way to create a [base image]. The base image heavily depends on the distribution, the host is running. The example script [mkimage-debootstrap.sh] creates a debian base image.

[base image]: http://docs.docker.io/en/latest/articles/baseimages/
[mkimage-debootstrap.sh]: https://github.com/dotcloud/docker/blob/master/contrib/mkimage-debootstrap.sh

2.3.1 Download the script 
==========================


  $ wget https://raw.github.com/dotcloud/docker/master/contrib/mkimage-debootstrap.sh
  $ chmod +x mkimage-debootstrap.sh

This downloads the build-script for a debian docker base image.

2.3.2 Build the base image 
===========================


  $ ./mkimage-debootstrap.sh flora/debian wheezy 
  $ docker images -a

This creates a new docker base image for debain wheezy and puts it into ropsitory /flora/debian/, where /flora/ is the username and /debian/ the repo name.

3 Installing a /Scala/Java/ WebApp 
-----------------------------------
As a proof of concept, we install a /Scala/ WebApp with /Lift/. We need /Java/ version > 6 and we use /Lift/ as the framework. 

3.1 Installing /Java/ and /Lift/ 
=================================

3.1.1 The necessary debian packages 
====================================
We need /jdk/ at least version 6, /wegt/ and /zip/:


  $ apt-get install -y openjdk-7-jre
  $ apt-get install -y openjdk-7-jdk
  $ apt-get install -y wget
  $ apt-get install -y zip

This installs Java 7 and my take a minute.

3.1.2 TODO check if we need apache packages? 
=============================================

3.1.3 Scala WebApp 
===================
We download and configure a sample /Scala/ WebApp and generate the War-file.


  $ cd /opt
  $ wget https://github.com/Lift/Lift_26_sbt/archive/master.zip
  $ unzip master.zip
  $ cd lift_26_sbt-master/scala_210/lift_basic/
  $ ./sbt  compile
  $ ./sbt  package

[/Lift/ web framework]  will download /sbt/, /Scala/ and the necessary dependencies and compile the War-File */opt/lift\_26\_sbt-master/scala\_210/lift\_basic/target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war*. By typing


  $ ./sbt 
  > start

we should be able to see the WebApp at [http://localhost:8080]. To exit just type =exit=. The source of this WebApp is under */opt/lift\_26\_sbt-master/scala\_210/lift\_basic/src/main/webapp/*. To prove the concept, we will later just change /index.html/.

[/Lift/ web framework]: http:///Lift/web.net/getting_started

3.2 Installing tomcat7 
=========================
We use /tomcat/ as the *Apache Tomcat Servlet/JSP* engine to serve our /Scala/ WebApp, installing it by typing:


  $ apt-get install tomcat7

Tomcat serves servlets  at [http://localhost:8080]. The debian package starts the service automatically at boot time via /etc/init.dtomcat7 script.

3.3 Deploying the WebApp to tomcat7 
======================================
/Lift/ uses /sbt/ to compile the project and output a WAR- or JAR-file, which we want to copy into tomcat7's webapp directory */var/lib/tomcat7/webapps/*. We recompile the package and deploy it statically into /tomcat/.


  $ cd /opt/lift_26_sbt-master/scala_210/lift_basic/
  $  ./sbt  package
  $ cp  target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war \
      /var/lib/tomcat7/webapps/lift.war
  $ service tomcat7 restart

This copies the war-file and restarts tomcat7. To see the WebApp direct your browser to [http://localhost:8080/lift_basic/]. There is no need to restart /tomcat/ manually, as the /autoDeploy/ attribute is set to "true" in file */etc/tomcat7/server.xml*. /tomcat/ even unpacks war-files if attribute /unpackWARs/ is set to "true".

4 Installing Jenkinsx 
----------------------
How to install a jenkins server

5 Configure Jenkins to publish a container into the registry 
-------------------------------------------------------------

Each time the WebApp has changed in git, Jenkins builds a new container,  consisting of three parts:
1. Deploying the WebApp-Files into the latest container.
2. Commit the newly build container and tag it properly.
3. Start the newly taged container.
