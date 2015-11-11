#! /bin/bash

sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get clean
sudo apt-get update 
sudo apt-get -y install openjdk-8-jdk
sudo echo export JAVA_HOME=\"$(readlink -f $(which javac) | grep -oP '.*(?=/bin)')\" >> /root/.bash_profile
sudo echo export JDK_HOME=\"$(readlink -f $(which javac) | grep -oP '.*(?=/bin)')\" >> /root/.bash_profile
sudo source /root/.bash_profile
sudo wget https://bintray.com/artifact/download/sbt/debian/sbt-0.13.9.deb
sudo dpkg -i sbt-0.13.9.deb
sudo apt-get clean
sudo apt-get update
sudo apt-get -y install git
sudo wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
sudo tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/
sudo ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/bin/mvn
export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
sudo apt-get clean
sudo apt-get update
sudo apt-get -y install protobuf-compiler