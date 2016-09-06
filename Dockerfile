# ib-tomcat-base
FROM  centos

# TODO: Put the maintainer name in the image metadata
MAINTAINER Justin Davis <justinndavis@gmail.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Image for building micro-service based tomcat deployments" \
      io.k8s.display-name="builder 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.0.0,tomcat,http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# TODO: Install required packages here:
RUN yum install -y wget curl java-1.7.0-openjdk-devel && yum clean all -y
RUN mkdir -p /ib/appl
RUN cd /ib/appl
RUN wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz
RUN tar xvf apache-tomcat-7.0.70.tar.gz
RUN ln -s apache-tomcat-7.0.70 tomcat7

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
RUN mkdir -p /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

RUN chgrp -R 0 /ib/appl
RUN chmod -R g+rw /ib/appl
RUN find /ib/appl -type d -exec chmod g+x {} +

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]