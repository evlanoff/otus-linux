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
### Запрещаем вход всем кроме группы admin
Добавить в `vi /etc/pam.d/system-auth`
```sh
account required    pam_access.so
```
Правим `/etc/security/access.conf`
```sh
- :ALL EXCEPT root vagrant (admin):ALL
```
*root/vagrant оставлены для тестов*

Далее запрещаем им вход по выходным и праздникам. (Не работает с праздниками)

Делаем это с помощью `/etc/security/time.conf`
```sh
* ; * ; !admin; Wk
```
## 2
### Способ 1
Редактируем `sudoers`
```console
test1 ALL=(ALL:ALL)     ALL
%test1 ALL=(ALL)        NOPASSWD: ALL
```
### Способ 2
Подсмотрен [тут](https://unix.stackexchange.com/a/454810)
```console
echo "cap_sys_admin   test1" > /etc/security/capability.conf
```
Добавить в начало файла до `pam_rootok.so`
```console
sed -i "1i auth   optional    pam_cap.so" /etc/pam.d/su
```

### Справочный материал:

[pam_succeed_if](http://www.linux-pam.org/Linux-PAM-html/sag-pam_succeed_if.html)
[pam_script](http://manpages.ubuntu.com/manpages/cosmic/man7/pam-script.7.html)
[pam_time](http://www.linux-pam.org/Linux-PAM-html/sag-pam_time.html)
[capabilities](http://man7.org/linux/man-pages/man7/capabilities.7.html)


Как вариант посмотреть в сторону. И заскриптовать sshd с pam_script
`vi /etc/pam.d/system-auth`
```sh
auth    required    pam_succeed_if.so gid = 
```
