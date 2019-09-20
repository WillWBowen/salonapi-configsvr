FROM maven:3-jdk-11 as BUILD

COPY . /usr/src/app
RUN mvn --batch-mode -f /usr/src/app/pom.xml clean package

FROM openjdk:8-jdk-alpine
MAINTAINER William Bowen <willwbowen@gmail.com>
RUN apk update && apk upgrade && apk add netcat-openbsd
RUN mkdir -p /usr/local/configsvr
RUN cd /tmp/ && \
    wget "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
    --header 'Cookie:oraclelicense=accept-securebackup-cookie' &&  \
    unzip jce_policy-8.zip && rm jce_policy-8.zip && \
    yes | cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar $JAVA_HOME/jre/lib/security/
COPY --from=BUILD usr/src/app/target/salonapi-configsvr*SNAPSHOT.jar /usr/local/configsvr/app.jar
COPY run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh
