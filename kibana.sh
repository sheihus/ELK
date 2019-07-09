#!/bin/bash

source functions

cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo yum clean all
sudo yum makecache

packets=('mc' 'java-openjdk-devel' 'java-openjdk' 'elasticsearch' 'kibana')
for p in ${packets[@]}
{
  yuminstall ${p}
}


cp /vagrant/kibana.yml /etc/kibana/
cp /vagrant/elasticsearch.yml /etc/elasticsearch/
cp /vagrant/filebeat.yml /etc/filebeat/

sudo systemctl daemon reload

serv=('elasticsearch' 'kibana' 'elasticsearch' )
for s in ${packets[@]}
{
  enstart ${s}
}

