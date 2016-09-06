# ib-tomcat-base
FROM  centos

# TODO: Put the maintainer name in the image metadata
MAINTAINER Justin DAvis <justinndavis@gmail.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Imaging for build micro-service based tomcat deployment" \
      io.k8s.display-name="builder 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.0.0,tomcat,http"

# TODO: Install required packages here:
RUN yum install -y wget curl java-1.7.0-openjdk-devel && yum clean all -y


RUN mkdir -p /ib/appl

WORKDIR /ib/appl
## Create user
RUN groupadd gibcomadm
RUN useradd -d /ib/appl -s /bin/bash -G gibcomadm ibcomadm
RUN passwd -f -u ibcomadm
RUN echo ibcomadm | passwd --stdin ibcomadm

RUN cd /ib/appl
RUN wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz
RUN tar xvf apache-tomcat-7.0.70.tar.gz
RUN ln -s apache-tomcat-7.0.70 tomcat7
#RUN rm -rf /ib/appl/tomcat7/bin/*.bat
#RUN rm -rf apache-tomcat-7.0.70.tar.gz

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
RUN mkdir -p /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R ibcomadm:gibcomadm /ib/appl


# TODO: Set the default port for applications built using this image

EXPOSE 8080

#CMD ["/ib/appl/tomcat7/bin/catalina.sh", "run"]
CMD ["/usr/libexec/s2i/usage"]