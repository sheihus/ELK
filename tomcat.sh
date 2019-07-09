#!/bin/bash

source functions

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF | sudo tee /etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF


packets=('mc' 'java-openjdk-devel' 'java-openjdk' 'logstash' 'filebeat')
for p in ${packets[@]}
{
  yuminstall ${p}
}

cp /vagrant/deploy.conf /etc/logstash/conf.d/
cp /vagrant/filebeat.yml /etc/filebeat/


#First, create a new tomcat group:
sudo groupadd tomcat

#Then create a new tomcat user.
sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

cd ~
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz
sudo mkdir /opt/tomcat
sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

#Change to the Tomcat installation path:
cd /opt/tomcat

#Give the tomcat group ownership over the entire installation directory:
sudo chgrp -R tomcat /opt/tomcat

#Next, give the tomcat group read access to the conf directory and all of its contents, and execute access to the directory itself:
sudo chmod -R g+r conf
sudo chmod g+x conf


#Then make the tomcat user the owner of the webapps, work, temp, and logs directories:
sudo chown -R tomcat webapps/ work/ temp/ logs/

cd /home/vagrant
echo ... copy tomcat.service file
cp tomcat.service /etc/systemd/system/

# deploying war application
cp TestApp.war /opt/tomcat/webapps/


sudo systemctl daemon-reload

services=('filebeat' 'tomcat' 'logstash')
for s in ${services[@]}
{
  enstart ${s}
}
