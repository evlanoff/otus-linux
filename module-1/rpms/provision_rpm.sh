#!/usr/bin/env bash

cd /home/vagrant

mkdir fifs-1.0 -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
curl -o fifs-1.0/fifs.sh https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/find_ip_from_subnet.sh
curl -o fifs-1.0/access.log https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/access.log

tar -czvf rpmbuild/SOURCES/fifs-1.0.tar.gz fifs-1.0/
mv fifs.spec rpmbuild/SPECS/fifs.spec
rpmbuild -bb rpmbuild/SPECS/fifs.spec

