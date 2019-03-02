#!/usr/bin/env bash

yum install nginx createrepo w3m -y
mkdir -p /usr/share/nginx/html/repo
cp fifs-1.0.noarch.rpm /usr/share/nginx/html/repo/
curl -o /usr/share/nginx/html/repo/nano-2.3.1-10.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm
sed -i -e '48i\\          autoindex on;' nginx.conf

createrepo /usr/share/nginx/html/repo/
cat >> /etc/yum.repos.d/otus-homework.repo << EOF
[otus-homework]
name=otus-homework
baseurl=http://localhost/
gpgcheck=0
enabled=1
EOF
