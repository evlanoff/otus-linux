#!/usr/bin/env bash

yum install epel-release nginx createrepo w3m -y
mkdir -p /usr/share/nginx/html/repo
cp /home/vagrant/rpmbuild/RPMS/noarch/fifs-1.0-1.e17.noarch.rpm /usr/share/nginx/html/repo/
#curl -o /usr/share/nginx/html/repo/fifs-1.0-1.e17.noarch.rpm https://github.com/evlanoff/otus-linux/raw/master/module-1/rpms/fifs-1.0-1.el7.noarch.rpm
curl -o /usr/share/nginx/html/repo/nano-2.3.1-10.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm
sed -i '42d' /etc/nginx/nginx.conf
sed -i -e '42i\\     root     /usr/share/nginx/html/repo;' /etc/nginx/nginx.conf
sed -i -e '48i\\          autoindex on;' /etc/nginx/nginx.conf

createrepo /usr/share/nginx/html/repo/

systemctl enable nginx
systemctl start nginx
    
cat >> /etc/yum.repos.d/otus-homework.repo << EOF
[otus-homework]
name=otus-homework
baseurl=http://localhost/
gpgcheck=0
enabled=1
EOF

