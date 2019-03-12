cp /vagrant/myunit.service /etc/systemd/system/
cp /vagrant/myownunit.timer /etc/systemd/system/
cp /vagrant/myownlog /etc/sysconfig/
cp /vagrant/logger.sh /opt/
chmod 755 /opt/logger.sh

systemctl enable myunit.service myownunit.timer
systemctl start myunit.service myownunit.timer
