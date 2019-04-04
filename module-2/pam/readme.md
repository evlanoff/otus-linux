# PAM

1. Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни
2. Дать конкретному пользователю права рута


## 1
### Устанавливаем заисимости
```sh
yum install epel-release -y
yum install pam_script -y
```
### Заводим юзеров test1, test2 и группу admin, в которую в ключаем юзеров.
```sh
groupadd admin
useradd -G admin test1
echo qwerty2$ | passwd test1 --stdin
echo qwerty2$ | passwd test2 --stdin
```
### Запрещаем всем вход кроме группы admin
Добавить в `vi /etc/pam.d/system-auth`
```sh
account required    pam_access.so
```
Правим `/etc/security/access.conf`
```sh
- :ALL EXCEPT root vagrant (admin):ALL
```
*root/vagrant оставлены для тестов*



Далее запрещаем им вход по выходным и праздникам.

Делаем это с помощью `/etc/security/time.conf`
```sh
* ; * ; !admin; Wk
```

## 2

Справочный материал:

[pam_succeed_if](http://www.linux-pam.org/Linux-PAM-html/sag-pam_succeed_if.html)
[pam_script](http://manpages.ubuntu.com/manpages/cosmic/man7/pam-script.7.html)
[pam_time](http://www.linux-pam.org/Linux-PAM-html/sag-pam_time.html)
