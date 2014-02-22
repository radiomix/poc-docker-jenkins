#
#
#
#+Options: toc:3
#
#
#


* Overview
** Purpose
This paper documents the Proof of Concept Project:
*Enable a Jenkins build server to publish release artifacts as* /Docker/ *images to a* /Docker/ *reegistry. Start
service on a new EC2 node by fetching the artifact from the registry.*
** Author
 - Author: Michael Klöckner, Weberstr. 39, 60318 Frankfurt am Main, 
 - Email:mkl@im7.de
 - Phone: +49 69 9866 1103
** /Docker/ version
   We installed /Docker/ version 0.8 in 2014/02.
** Deployment workflow
One major issue in Continuous Integration is to insure a once deployed build artifact never changes in future deployment scenarios. /Docker/ versions each container, making it immutable after a =docker build=. To start a particular container, beeing pulled out of a repository, results in starting the same build artifact in all future deployment scenarios. We use the /Jenkins/ server to build a docker container triggered by a git push. This container is then pulled and started by the production environment.
 [[file:/debiandata/michael/elemica/docker/poc-docker-jenkins/img/docker-deployment-workflow-01.jpg]]
* /Docker/
This chapter deals with installation issues and some basic /Docker/ commands. It is mainly take from the [[http://docs.docer.io/en/latest/][Docker documentation]]. 
** TODO explain /docker/ terminology: Image, Container, Repository, Registry, Index.
** Installation
*** Kernel options
/Docker/ needs a 64-Bit Linux distribution, a recent kernel > 3.8 and LXC
installed. Either you use a system with the appropriate kernel installed, or
you update the kernel by hand as described in kernel compilation. The ker-
nel needs to have compiled all options concerning virtual NICs, especially
BRIDGED NICs, all NAT options and all net  ( NF ) options. Download
the kernel source, untar it, change into the directory and configure it prop-
erly. To compile the kernel as a debian package named *fora-kernel-3.13.3*
to be installed later together with it's header follow these instructions:
#+BEGIN_SRC sh
make-kpkg clean
make-kpkg --append-to-version "-flora-kernel-3.13.3" --revision "1" \
--initrd kernel_image kernel_headers
#+END_SRC
The package is to be found one directory upwards and can be installed using
#+BEGIN_SRC sh
dpkg -i ../linux-headers-3.13.3-flora-kernel-3.13.3_1.2_amd64.deb \
../linux-image-3.13.3-flora-kernel-3.13.3_1.2_amd64.deb/.
#+END_SRC
*** Installation by hand
First add the /Docker/ repository key to your local keychain.
#+BEGIN_SRC sh
sudo apt-key adv --keyserver keyserver.ubuntu.com \
--recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
#+END_SRC
Add the /Docker/ repository to your apt sources list, update and install
the lxc-docker package.
#+BEGIN_SRC sh
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main\
> /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker
#+END_SRC
Now verify that the installation has worked by downloading the ubuntu
image and launching a container. =sudo docker run -i -t ubuntu /bin/bash=.
Type exit to exit.
*** Installation by script
Docker.io provides an installation script to be called: =curl -s https://get.docker.io/ubuntu/ | sudo sh=
Now verify that the installation has worked by downloading the ubuntu
image and launching a container. =sudo docker run -i -t ubuntu /bin/bash=
Type exit to exit.
*** Installing on AWS
Docker.io provides an installation guide for Amazon Web Services EC2.
- Choose an image: 
  + Launch the Create Instance Wizard menu on your AWS Console.
  + Click the Select button for a 64Bit Ubuntu image. For example: Ubuntu Server 12.04.3 LTS. 
  + For testing you can use the default (possibly free) t1.micro instance (more info on pricing). 
  + Click the Next: Configure Instance Details button at the bottom right.
- Tell CloudInit to install /Docker/:
  + When you're on the Configure Instance Details step, expand the Advanced Details section.
  + Under User data, select As text
  + Enter #include https://get.docker.io  into the instance User Data. CloudInit is part of the Ubuntu image you chose; it will bootstrap /Docker/ by running the shell script located at this URL.
- After a few more standard choices where defaults are probably ok, your AWS Ubuntu instance with /Docker/ should be running!
If this is your first AWS instance, you may need to set up your Security Group to allow SSH. By default all incoming ports to your new instance will be blocked by the AWS Security Group, so you might just get
timeouts when you try to connect. Installing with get.docker.io (as above) will create a service named lxc-
docker. It will also set up a /docker/ group and you may want to add the ubuntu user to it so that you don't have to use sudo for every /Docker/ command.
*** Configuration 
- The daemon's config file is placed in /etc/default/docker/.  
- Images, containers and their configurations are placed under /var/lib/docker/. 
** Play with /Docker/
We describe some basic /Docker/ commands.
*** Check your /Docker/ installation.
#+BEGIN_SRC bash
# Check that you have a working install
docker info
#+END_SRC 
*** Download a pre-built image
#+BEGIN_SRC bash
# Download an ubuntu image
sudo docker pull ubuntu
#+END_SRC
*** Run an interactive shell
#+BEGIN_SRC bash
# Run an interactive shell in the ubuntu image,
# allocate a tty, attach stdin and stdout
# To detach the tty without exiting the shell,
# use the escape sequence Ctrl-p + Ctrl-q
sudo docker run -i -t ubuntu /bin/bash
#+END_SRC
*** Bind to a port
The /Docker/ client can use -H to connect to a custom port.
-H accepts host and port assignment in the following format: 
- tcp://[host][:port]  =
- unix://path =
- host[:port] or :port =

#+BEGIN_SRC bash
# Run docker in daemon mode
sudo <path to>/docker -H 0.0.0.0:5555 -d &
# Download an ubuntu image
sudo docker -H :5555 pull ubuntu
#+END_SRC
*** Starting a long run
#+BEGIN_SRC bash
# Start a very useful long-running process
JOB=$(sudo docker run -d ubuntu /bin/sh -c "while true; \
do echo Hello world; sleep 1; done")
# Collect the output of the job so far
sudo docker logs $JOB
# Kill the job
sudo docker kill $JOB
#+END_SRC
*** Bind a service on a TCP port
#+BEGIN_SRC bash
# Bind port 4444 of this container, and tell netcat to listen on it
JOB=$(sudo docker run -d -p 4444 ubuntu:12.10 /bin/nc -l 4444)

# Which public port is NATed to my container?
PORT=$(sudo docker port $JOB 4444 | awk -F: '{ print $2 }')

# Connect to the public port
echo hello world | nc 127.0.0.1 $PORT

# Verify that the network connection worked
echo "Daemon received: $(sudo docker logs $JOB)"
#+END_SRC
*** Committing (saving) a container state
Save your containers state to a container image, so the state can be re-used.
When you commit your container only the differences between the image the container was created from and the current state of the container will be stored (as a diff). See which images you already have using the /Docker/ images command.
#+BEGIN_SRC bash
# Commit your container to a new named image
sudo docker commit <container_id> <some_name>

# List your containers
sudo docker images
#+END_SRC
*** Committing a Container to a Named Image
When you make changes to an existing image, those changes get saved to a container’s file system. You can then promote that container to become an image by making a commit. In addition to converting the container to an image, this is also your opportunity to name the image, specifically a name that includes your user name from the Central /Docker/ Index (as you did a login above) and a meaningful name for the image.
#+BEGIN_SRC sh
# format is "sudo docker commit <container_id> <username>/<imagename>"
$ sudo docker commit $CONTAINER_ID myname/kickassapp
#+END_SRC
*** Pushing an image to its repository
In order to push an image to its repository you need to have committed your container to a named image (see above).
Now you can commit this image to the repository designated by its name or tag.
#+BEGIN_SRC sh
# format is "docker push <username>/<repo_name>"
$ sudo docker push myname/kickassapp
#+END_SRC
*** Private Repositories
Right now (version 0.6), private repositories are only possible by hosting [[https://github.com/dotcloud/docker-registry][your private registry]]. To push or pull to a repository on your own registry, you must prefix the tag with the address of the registry’s host, like this:
#+BEGIN_SRC sh
# Tag to create a repository with the full registry location.
# The location (e.g. localhost.localdomain:5000) becomes
# a permanent part of the repository name
sudo docker tag 0u812deadbeef localhost.localdomain:5000/repo_name
# Push the new repository to its home location on localhost
sudo docker push localhost.localdomain:5000/repo_name
#+END_SRC
Once a repository has your registry’s host name as part of the tag, you can push and pull it like any other repository, but it will not be searchable (or indexed at all) in the Central Index, and there will be no user name checking performed. Your registry will function completely independently from the Central Index.
*** Export a container
To export a container to a tar file just type:
#+BEGIN_SRC sh
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
mkl/debian          7.4                 11ed3d47ec89        About an hour ago   117.8 MB
mkl/debian          latest              11ed3d47ec89        About an hour ago   117.8 MB
mkl/debian          wheezy              11ed3d47ec89        About an hour ago   117.8 MB
ubuntu              13.10               9f676bd305a4        2 weeks ago         182.1 MB
ubuntu              saucy               9f676bd305a4        2 weeks ago         182.1 MB

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
ac3a595c294c        mkl/debian:7.4      /bin/bash           58 minutes ago      Exit 1                                  prickly_lovelace    
f7528d270208        mkl/debian:7.4      echo success        About an hour ago   Exit 0                                  jovial_pare         
6a569d77e974        ubuntu:12.04        /bin/bash           16 hours ago        Exit 0                                  backstabbing_pike 

$ docker export ac3a595c294c  > exampleimage.tar
#+END_SRC
*** Import a container
At this time, the URL must start with http and point to a single file archive (.tar, .tar.gz, .tgz, .bzip, .tar.xz, or .txz) containing a root filesystem. If you would like to import from a local directory or archive, you can use the - parameter to take the data from stdin.
To import from a remote url type:
#+BEGIN_SRC sh
$ sudo docker import http://example.com/exampleimage.tar
#+END_SRC
To import from a local file type:
#+BEGIN_SRC sh
$ cat exampleimage.tar | sudo docker import - exampleimagelocal:new
#+END_SRC
Note the sudo in this example – you must preserve the ownership of the files (especially root ownership) during the archiving with tar. If you are not root (or the sudo command) when you tar, then the ownerships might not get preserved.
*** Authentication file

The authentication is stored in a json file, .dockercfg located in your home directory. It supports multiple registry urls.

docker login will create the “https://index.docker.io/v1/” key.

docker login https://my-registry.com will create the “https://my-registry.com” key.

For example:
#+BEGIN_SRC JASON
{
     "https://index.docker.io/v1/": {
             "auth": "xXxXxXxXxXx=",
             "email": "email@example.com"
     },
     "https://my-registry.com": {
             "auth": "XxXxXxXxXxX=",
             "email": "email@my-registry.com"
     }
}
#+END_SRC
The auth field represents base64(<username>:<password>)

*** Mount a volume
/Docker/ provides the parameter =-v= with the =run= command to create a persitent storage device. 
#+BEGIN_SRC sh
docker run -v /volume1  myName/debian true
#+END_SRC sh
runs the image =myName/debian= with command =true= and creates a volume  attached to this container which is visable inside as =/volume1=. 
To mount the host directory =/opt/this-volume= to a container in read only mode, we prepend the host directory name to the volume name: 
#+BEGIN_SRC sh
docker run -v /opt/this-volume:/volume1:ro  myName/debian true
#+END_SRC  
If you remove containers that mount volumes, the volumes will not be deleted until there are no containers still referencing those volumes. This allows you to upgrade, or effectivly migrate data volumes between containers.
The complete syntax is
#+BEGIN_SRC sh
-v=[]: Create a bind mount with: [host-dir]:[container-dir]:[rw|ro].
#+END_SRC
If host-dir is missing from the command, then docker creates a new volume. If host-dir is present but points to a non-existent directory on the host, Docker will automatically create this directory and use it as the source of the bind-mount.
Note that this is not available from a Dockerfile due the portability and sharing purpose of it. The host-dir volumes are entirely host-dependent and might not work on any other machine. [[*Container%20and%20Images][Section Container and Images]] describes, where /Docker/ stores the volumes mounted by the container.
** Build your own base image
Docker.io provides a way to create a [[http://docs.docker.io/en/latest/articles/baseimages/][base image]]. The base image heavily depends on the distribution, the host is running. The example script [[https://github.com/dotcloud/docker/blob/master/contrib/mkimage-debootstrap.sh][mkimage-debootstrap.sh]] creates a debian base image.
*** Download the script
#+BEGIN_SRC sh
$ wget https://raw.github.com/dotcloud/docker/master/contrib/mkimage-debootstrap.sh
$ chmod +x mkimage-debootstrap.sh
#+END_SRC
This downloads the build-script for a debian /Docker/ base image.
*** Build the base image
#+BEGIN_SRC sh
$ ./mkimage-debootstrap.sh flora/debian wheezy 
$ docker images -a
#+END_SRC
This creates a new /Docker/ base image for debain wheezy and puts it into ropsitory /flora/debian/, where /flora/ is the username and /debian/ the repo name.
** Layers
   When Docker mounts the rootfs, it starts read-only, as in a traditional Linux boot, but then, instead of changing the file system to read-write mode, it takes advantage of a union mount to add a /read-write file system over the read-only file system/. In fact there may be multiple read-only file systems stacked on top of each other. We think of each one of these file systems as a *layer*. [[file:/debiandata/michael/elemica/docker/poc-docker-jenkins/img/docker-filesystems-multilayer.png]].
*** Union file system 
At first, the top read-write layer has nothing in it, but any time a process creates a file, this happens in the top layer. And if something needs to update an existing file in a lower layer, then the file gets copied to the upper layer and changes go into the copy. The version of the file on the lower layer cannot be seen by the applications anymore, but it is there, unchanged. We call the union of the read-write layer and all the read-only layers a *union file system*.
*** Base Image
[[file:/debiandata/michael/elemica/docker/poc-docker-jenkins/img/docker-filesystems-debianrw.png]]
In Docker terminology, a read-only Layer is called an image. An image never changes.
[[file:/debiandata/michael/elemica/docker/poc-docker-jenkins/img/docker-filesystems-multilayer.png]]
Each image may depend on one more image which forms the layer beneath it. We sometimes say that the lower image is the parent of the upper image. An image that has *no parent* is a *base image*.
All images are identified by a 64 hexadecimal digit string (internally a 256bit value). To simplify their use, a short ID of the first 12 characters can be used on the command line. There is a small possibility of short id collisions, so the docker server will always return the long ID.
** Container and Images
As /Docker/ is under heavy development, the file system storing /Docker/ related information changes rapidly. The main directory to look for /Docker/ relevant bits and bytes is /var/lib/docker/. In this section *GUID* is the full blown container id as given by =docker ps -a -no-trunc=.
*** LXC configuration
Using the Linux Container package [[/lxc/][http://linuxcontainers.org/]], /Docker/ configures each container partly by setting lxc options in /var/lib/docker/container/GUID/config.lxc/. 
*** [#A] Container Root File System
The corresponding root file system is stored in /var/lib/docker/devicemapper/mnt/GUID/rootfs/.
Here GUID is the full blown container id as given by =docker ps -a -no-trunc=  
*** Container Volumes
    If a container mounts a volume from inside the files on that volume are stored under /var/lib/docker/vfs/dir/GUID/. Data stored under these volumes are persistent between container runs. There is a way to share these volumes between containers. 
*** Removing a Container or an Image
To remove a container from a repository we just type:
#+BEBIN_SRC sh
docker rm GUID
#+END_SRC
To remove an image from a repository we just type:
#+BEBIN_SRC sh
docker rmi GUID
#+END_SRC
* Installing a /Scala/Java/ WebApp
As a proof of concept, we install a /Scala/ WebApp with /Lift/. We need /Java/ version > 6 and we use /Lift/ as the framework. 
** Installing /Java/ and /Lift/
*** The necessary debian packages
We need /jdk/ at least version 6, /wegt/ and /zip/:
#+BEGIN_SRC sh
$ apt-get update
$ apt-get install -y openjdk-7-jre
$ apt-get install -y openjdk-7-jdk
$ apt-get install -y wget
$ apt-get install -y zip
#+END_SRC
This installs Java 7 and my take a minute.
*** TODO check if we need apache packages?
*** Scala WebApp
We download and configure a sample /Scala/ WebApp and generate the War-file.
#+BEGIN_SRC sh
$ cd /opt
$ wget https://github.com/Lift/Lift_26_sbt/archive/master.zip
$ unzip master.zip
$ cd lift_26_sbt-master/scala_210/lift_basic/
$ ./sbt  compile
$ ./sbt  package
#+END_SRC 
[[http:///Lift/web.net/getting_started][/Lift/ web framework]]  will download /sbt/, /Scala/ and the necessary dependencies and compile the War-File */opt/lift\_26\_sbt-master/scala\_210/lift\_basic/target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war*. By typing
#+BEGIN_SRC sh
$ ./sbt 
> start
#+END_SRC
we should be able to see the WebApp at [[http://localhost:8080]]. To exit just type =exit=. The source of this WebApp is under */opt/lift\_26\_sbt-master/scala\_210/lift\_basic/src/main/webapp/*. To prove the concept, we will later just change /index.html/.
** Installing /tomcat7/
We use /tomcat/ as the *Apache Tomcat Servlet/JSP* engine to serve our /Scala/ WebApp, installing it by typing:
#+BEGIN_SRC sh
$ apt-get update
$ apt-get install -y tomcat7 
#+END_SRC  
Tomcat serves servlets  at [[http://localhost:8080]]. The debian package starts the service automatically at boot time via /etc/init.d/tomcat7/ script.
** Deploying the WebApp to /tomcat7/
/Lift/ uses /sbt/ to compile the project and output a WAR- or JAR-file, which we want to copy into /tomcat7/'s webapp directory */var/lib/tomcat7/webapps/*. We recompile the package and deploy it statically into /tomcat/.
#+BEGIN_SRC sh 
$ cd /opt/lift_26_sbt-master/scala_210/lift_basic/
$  ./sbt  package
$ cp  target/scala-2.10/lift-2.6-starter-template_2.10-0.0.3.war \
    /var/lib/tomcat7/webapps/lift.war
$ service tomcat7 restart
#+END_SRC 
This copies the war-file and restarts /tomcat7/. To see the WebApp direct your browser to [[http://localhost:8080/lift_basic/]]. There is no need to restart /tomcat/ manually, as the /autoDeploy/ attribute is set to "true" in file */etc/tomcat7/server.xml*. /tomcat/ even unpacks war-files if attribute /unpackWARs/ is set to "true".
** Building a container with the WebApp
*** The Dockerfile
We use =docker build= command to build the WebApp container from this docker file.

* Installing Jenkins
How to install a jenkins server
* Configure Jenkins to publish a container into the registry

Each time the WebApp has changed in git, Jenkins builds a new container,  consisting of three parts:
1. Deploying the WebApp-Files into the latest container.
2. Commit the newly build container and tag it properly.
3. Start the newly taged container.

# LocalWords:  WebApp
