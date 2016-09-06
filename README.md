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

Should get usage message

to run s2i to build something useful :

s2i build . ib-tomcat-base ib-tomcat-jenkins

then

docker run -d -p 8080:8080 ib-tomcat-base