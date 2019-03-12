# Создание юнита

myunit.service - основной сервис

myownunit.timer - таймер для сервиса

myownlog - файл с переменными

logger.sh - скрипт, который запускает сервис


**Запуск сервиса и таймера**

```console
sudo systemctl enable myunit.service myownunit.timer
sudo systemctl start myunit.service myownunit.timer
```

Просмотр работы скрипта

```console
sudo tail -f /var/log/messages
```

Остановка сервиса

```console
sudo systemctl start myunit.service myownunit.timer
sudo systemctl stop myunit.service myownunit.timer
```

# Создание unit-файла для spawn-fcgi

**Установка зависимостей**

```console
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
```

/etc/rc.d/init.d/spawn-fcgi - cам Init скрипт, который будем переписывать

**Расскомментировать строки с переменными в /etc/sysconfig/spawn-fcgi**

/etc/sysconfig/spawn-fcgi 

sed -i '/SOCKET=/s/^#//' /etc/sysconfig/spawn-fcgi
sed -i '/OPTIONS=/s/^#//' /etc/sysconfig/spawn-fcgi

**Удаляем параметр отвечающий за PID-файл**

sed -i 's/-P \/var\/run\/spawn-fcgi.pid //g' spawn-fcgi

**Юнит-файл**

/etc/systemd/system/spawn-fcgi.service

[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
