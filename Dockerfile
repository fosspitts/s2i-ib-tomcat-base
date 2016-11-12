# ib-service-base
FROM  centos7

MAINTAINER Justin Davis <justinndavis@gmail.com>

EXPOSE 8080

ENV BUILDER_VERSION 1.0 \
 TOMCAT_VERSION 7.0.72 \
 JAVA_VERSION 1.7

LABEL name="Iberia Base Centos Tomcat Image" \
      vendor=Iberia \
      license=GPLv2

LABEL io.k8s.description="Image for building micro-service based tomcat deployments" \
      io.k8s.display-name="Iberia Base Centos Tomcat" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,tomcat,http,iberia" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm && \
 yum -y install wget curl java-1.7.0-openjdk-devel git ansible pyOpenSSL libxml2 libxslt && \
 yum clean all -y && \
 mkdir -p /ib/appl

WORKDIR /ib/appl

RUN wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz && \
 tar xvf apache-tomcat-7.0.72.tar.gz && \
 ln -s apache-tomcat-7.0.72 tomcat7 && \
 rm -rf apache-tomcat-7.0.72.tar.gz  && \
 mkdir -p /usr/libexec/s2i

COPY ./.s2i/bin/ /usr/libexec/s2i

RUN chgrp -R 0 /ib/appl && \
 chmod -R g+rw /ib/appl && \
 find /ib/appl -type d -exec chmod g+x {} +

USER 1001

CMD ["/usr/libexec/s2i/usage"]