#!/usr/bin/env bash

#mkdir fifs-1.0 -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

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
