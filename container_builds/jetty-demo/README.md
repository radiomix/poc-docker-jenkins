A simple container hosting the Jetty 9 servlet container.

To use:

    WEBAPPS=/somewhere/on/host/webapps
    mkdir $WEBAPPS # so it is owned by you, not root
    docker run -p 80:8080 -v $WEBAPPS:/opt/jetty/webapps jglick/jetty-demo &

Then to hot-deploy web apps:

    cp something.war $WEBAPPS

and browse: http://localhost/something/

(Or http://localhost/ lists currently running applications.)

Logs are sent to standard output so you can easily follow status.
