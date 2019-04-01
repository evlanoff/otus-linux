# Ansible

### Краткий алгоритм действий:
В vagrantfile создаём 3 машины: master, host1, host2. На master создаём ssh-ключ, по которому подключаемся к хостам. На хостах открываем доступ по логин/паролю пользователю root. *Данный способ небезопасен, только в научно-исследовательских целях.*

Всё на примере centos 7.

IP-адреса хостов:
```console
master    192.168.11.100
host1     192.168.11.101
host2     192.168.11.102
```
master — сервер с ansible.
host1/2 — хосты которыми ansible будет оперировать.

### Генерация ssh ключей

Тут всё просто. Генерируем на master ssh ключ отвечая на вопросы мастера. Не забыть заданный пароль для passphrase.

```console
ssh-keygen
```
### Настройка хостов для подключения
Для подключения из ansible необходимо разрешить коннектиться к хостам пользователем root. На хостах применяем команды:
```console
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i '38s/#//' /etc/ssh/sshd_config
systemctl restart sshd
```
Параметр `PasswordAuthentication` позволяет авторизоваться на сервере при помощи заданного пароля -- `passphrase` сгенирированного ключа.

Добавляем ssh ключ в агент. Подробнее про [ssh-agent](https://linux.die.net/man/1/ssh-agent), [ssh-add](https://linux.die.net/man/1/ssh-add). Работает до выхода из сессии bash.
```console
ssh-agent bash
ssh-add ~/.ssh/id_rsa
```
### Копирование ключей с master на host
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
На мастер хосте заводим директорию `ansible` с inventory-файлом.
```console
cp /vagrant/ansible /root
```
`passphrase`, который вводили при генерации ssh ключа, необходимо добавить в hosts.txt параметру `ansible_ssh_pass` или `ansible_password` (оба варианта применяются).

### Установка nginx на хосты
```console
ansible-playbook epel.yml
```
Проверяем доступность nginx на порту 8080 у обоих хостов
```console
curl 192.168.11.101:8080
curl 192.168.11.102:8080
```
Полезная команда для отладки.
```console
ansible all -m ping -vvv
```
