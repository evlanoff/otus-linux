# Создание юнита

В Vagrantfile раскомментировать строку 61 для проверки работоспособности

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

В Vagrantfile раскомментировать строку 64 для проверки работоспособности

**Установка зависимостей**

```console
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
```

/etc/rc.d/init.d/spawn-fcgi - cам Init скрипт, который будем переписывать

**Расскомментировать строки с переменными в /etc/sysconfig/spawn-fcgi**

```console
/etc/sysconfig/spawn-fcgi 

sed -i '/SOCKET=/s/^#//' /etc/sysconfig/spawn-fcgi
sed -i '/OPTIONS=/s/^#//' /etc/sysconfig/spawn-fcgi
```

**Удаляем параметр отвечающий за PID-файл**

```console
sed -i 's/-P \/var\/run\/spawn-fcgi.pid //g' /etc/sysconfig/spawn-fcgi
```

**Юнит-файл**

```console
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
```

В Vagrantfile раскомментировать строку 67 для проверки работоспособности

(доделать, разобраться с httpd.conf файлами first, second. C PID-файлами разобраться, EnvironmentFile=/etc/sysconfig/httpd-%I это не работает уточнить)

cp /vagrant/httpd.service /etc/systemd/system/
cp /vagrant/httpd-first.conf /etc/sysconfig/
cp /vagrant/httpd-second.conf /etc/sysconfig/

Внутри поправить папки с html
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf


mkdir -p /var/www/html/{first,second}

cat >> /var/www/html/first/index.html <<-EOF
<h1>First</h1>
    EOF
    
cat >> /var/www/html/second/index.html <<-EOF
<h1>Second</h1>
    EOF

