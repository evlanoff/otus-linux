# Ansible

### Вводная

Краткий алгоритм действий:
В vagrantfile создаём 3 машины: master, host1, host2. На master создаём ссш-ключ, по которому подключаемся к хостам. Добавляем ключ на master в ссш-агент, копируем на хосты. На мастере ставим ансибл, пишем плэйбук/роль и накатываемн на хосты.

Всё на примере centos 7.

IP-адреса хостов:
```console
master   192.168.11.100
host1     192.168.11.101
host2     192.168.11.102
```
master — сервер с ansible.
host1/2 — хосты которыми ansible будет оперировать.

### Генерация ssh ключей

Тут всё просто. Генерируем на master ссш ключ отвечая на вопросы мастера. Не забыть заданный пароль для passphrase.

```console
ssh-keygen
```
### Копирование ключей с master на host

Чтобы добавить ssh ключи на host1/2 необходимо разрешить аутенфикацию логин/пароль.
```console
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```
Параметр `PasswordAuthentication` позволяет авторизоваться на сервере при помощи заданного пароля -- `passphrase` сгенирированного ключа.

Добавляем ключ в агент ссш. Подробнее про [ssh-agent](https://linux.die.net/man/1/ssh-agent), [ssh-add](https://linux.die.net/man/1/ssh-add).
```console
ssh-agent bash
ssh-add ~/.ssh/id_rsa
```

Копируем ключ с master на host1 и host2.
```console
ssh-copy-id 192.168.11.101
ssh-copy-id 192.168.11.102
```
### Установка ansible

Все действия выполняются на master.
```console
yum install epel-release -y
yum install ansible -y
```
На мастер хосте заводим директорию `ansible` с inventory-файлом. Копируем заранее подготовленный.

```console
cp /vagrant/ansible /root
```

Полезная команда для отладки.
```console
ansible all -m ping -vvv
```
