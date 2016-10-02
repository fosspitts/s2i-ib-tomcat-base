# ib-tomcat-base
FROM  centos

MAINTAINER Justin Davis <justinndavis@gmail.com>

ENV BUILDER_VERSION 1.0
ENV TOMCAT_VERSION 7.0.72
ENV JAVA_VERSION 1.7

LABEL name="Iberia Base Centos/Tomcat Image" \
      vendor=Iberia \
      license=GPLv2 \
      build-date=20161002

LABEL io.k8s.description="Image for building micro-service based tomcat deployments" \
      io.k8s.display-name="Iberia Base Centos/Tomcat 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.0.0,tomcat,http,iberia" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


#RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm


RUN mkdir -p /ib/appl
WORKDIR /ib/appl

COPY epel-release-7-8.noarch.rpm /ib/appl
RUN rpm -ivh /ib/appl/epel-release-7-8.noarch.rpm
RUN yum -y install wget curl java-1.7.0-openjdk-devel git ansible pyOpenSSL libxml2 libxslt
RUN yum clean all -y
RUN rm -rf epel-release-7-8.noarch.rpm

RUN wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz
RUN tar xvf apache-tomcat-7.0.72.tar.gz
RUN ln -s apache-tomcat-7.0.72 tomcat7
RUN rm -rf apache-tomcat-7.0.72.tar.gz

#RUN wget http://central.maven.org/maven2/ch/qos/logback/logback-classic/1.1.7/logback-classic-1.1.7.jar
#RUN mv logback-classic-1.1.7.jar /ib/appl/tomcat7/lib

#RUN wget http://central.maven.org/maven2/ch/qos/logback/logback-core/1.1.7/logback-core-1.1.7.jar
#RUN mv logback-core-1.1.7.jar /ib/appl/tomcat7/lib

#RUN wget http://central.maven.org/maven2/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.jar
#RUN mv slf4j-api-1.7.5.jar /ib/appl/tomcat7/lib

#RUN wget http://central.maven.org/maven2/org/slf4j/jcl-over-slf4j/1.7.5/jcl-over-slf4j-1.7.5.jar
#RUN mv jcl-over-slf4j-1.7.5.jar /ib/appl/tomcat7/lib

RUN mkdir -p /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

RUN chgrp -R 0 /ib/appl
RUN chmod -R g+rw /ib/appl
RUN find /ib/appl -type d -exec chmod g+x {} +

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
