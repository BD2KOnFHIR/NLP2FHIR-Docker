# Get the base image to Ubuntu
FROM ubuntu:19.10

RUN apt-get update && apt-get clean

RUN apt-get install -y wget

RUN apt-get install -y git

RUN apt-get install -y maven

RUN apt-get install unzip

RUN apt-get install -q -y openjdk-8-jre-headless openjdk-8-jdk && apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

ENV PATH $JAVA_HOME/bin:$PATH

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

ADD test.sh /

CMD bash /test.sh
