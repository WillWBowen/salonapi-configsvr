#!/bin/sh

echo "********************************************************"
echo "Starting Configuration Service on port $CONFIGSERVER_PORT"
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom -Dserver.port=$CONFIGSERVER_PORT \
      -Dspring.security.user.password=$CONFIGSERVER_PASSWORD \
     -jar /usr/local/configsvr/app.jar
