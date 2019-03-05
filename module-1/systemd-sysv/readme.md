# Создание юнита

#Кладём наш сервис в 

touch /etc/systemd/system/myownunit.service
chmod 0664 /etc/systemd/system/myownunit.service

/etc/sysconfig/myownunit

[Unit]
Description=Homework service
# After=network.target

[Service]
Type=notify
User=vagrant
#WorkingDirectory=/home/vagrant
EnvironmentFile=/etc/sysconfig/myownunit
ExecStart=/home/vagrant/my_daemon -D $OPTIONS
Restart=on-failure
# Other Restart options: or always, on-abort, etc

[Install]
WantedBy=multi-user.target


my_daemon.sh

chmod a+x my_daemon.sh

#!/usr/bin/env bash
