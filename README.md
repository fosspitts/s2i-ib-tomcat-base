# s2i-test
Testing Openshift's S2i capability


Build a base image running Centos7/OpenJDK 7/Tomcat7

Image built from Docker file

run :

make

or

docker build -t ib-tomcat-base .

Run the image locally on docker


docker run -d -p 8080:8080 ib-tomcat-base

Check :

http://localhost:8080

