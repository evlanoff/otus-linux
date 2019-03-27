# Ansible

## Вводная

Всё на примере centos 7.

В vagrantfile создаём 3 машины: master, host1, host2.

IP-адреса хостов:
```console
master   192.168.11.100
host1     192.168.11.101
host2     192.168.11.102
```
master — сервер с ansible.
host1/2 — хосты которыми ansible будет оперировать.

### Генерация ssh ключей

Тут всё просто. Генерируем на хостах ключи тупо отвечая на вопросы мастера. Не забыть заданный пароль для passphrase.

```console
ssh-keygen
```
### Копирование ключей с host1/2 на master

ПРИМЕЧАНИЕ: разобраться с ключами. Почему после генерации ssh ключи исчезают с host1/2(???)

Чтобы добавить ssh ключи на master необходимо разрешить аутенфикацию логин/пароль.
```console
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```
Параметр `PasswordAuthentication` позволяет авторизоваться на сервере при помощи заданного пароля, `passphrase` сгенирированного ключа.

Копируем ключи с host1 и host2 на master
```console
ssh-copy-id 192.168.11.100
```
### Установка ansible

Все действия выполняются на master.
```console
yum install epel-release -y
yum install ansible -y
```
На мастер хосте заводим директорию `ansible` с inventory--файлом. Копируем заранее подготовленный.

```console
cp /vagrant/ansible /root
```

Полезная команда для отладки.
```console
ansible all -m ping -vvv
```
