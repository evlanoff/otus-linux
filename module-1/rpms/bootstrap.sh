#!/usr/bin/env bash

mkdir fifs-1.0
rpmdev-setuptree

curl -o fifs-1.0/fifs.sh https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/find_ip_from_subnet.sh
curl -o fifs-1.0/access.log https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/access.log
curl -o rpmbuild/SPECS/fifs.spec https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/rpms/fifs.spec

#Патчим fifs.sh, чтобы видел журнал
sed -i '3d' fifs-1.0/fifs.sh
sed -i -e '3i\\ export ourlog='/opt/fifs/access.log'' fifs-1.0/fifs.sh

tar -czvf rpmbuild/SOURCES/fifs-1.0.tar.gz fifs-1.0/

rpmbuild -bb rpmbuild/SPECS/fifs.spec

mkdir -p /usr/share/nginx/html/repo

cp /home/vagrant/rpmbuild/RPMS/noarch/fifs-1.0-1.el7.noarch.rpm /usr/share/nginx/html/repo/
curl -o /usr/share/nginx/html/repo/nano-2.3.1-10.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm

#Правим nginx.conf для нашего репозитория
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
