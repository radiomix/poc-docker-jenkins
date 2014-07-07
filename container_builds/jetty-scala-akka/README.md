A simple Ścala/Lift example Web App inside the Jetty 9 servlet container.
Script `build.sh` installs openjdk-7-jdk, scala and sbt. It creates 
a sample WebApp hello -outputting just "Hi" from commandline. It compiles
and packages this WebApp into a jar file. It then creates a fresh docker
container to host jetty 9, ready to inject the scala jar file into.
The jar-file is located under /opt/hello/target/scala-2.10/ 



To use:

    WEBAPPS=/somewhere/on/host/webapps
    mkdir $WEBAPPS # so it is owned by you, not root
    docker run -p 80:8080 -v $WEBAPPS:/opt/jetty/webapps jglick/jetty-demo &

Then to hot-deploy web apps:

    cp something.war $WEBAPPS

and browse: http://localhost/something/

(Or http://localhost/ lists currently running applications.)

Logs are sent to standard output so you can easily follow status.
