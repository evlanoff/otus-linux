# Создание RPM пакета

Устанавливаем необходимые зависимости. (Сделать provisioning в Vagrantfile)

```console
yum install epel-release rpmdevtools rpm-build -y
```

Скачиваем в каталог fifs-1.0 файлы, которые будут упакованы в пакет.

```console
mkdir fifs-1.0 && cd fifs-1.0
curl -O https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/find_ip_from_subnet.sh
curl -O https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/access.log
mv find_ip_from_subnet.sh fifs.sh
```

Патчим путь до журнала, чтобы fifs.sh видел его

```console
sed -i '3d' fifs-1.0/fifs.sh
sed -i -e '3i\\ export ourlog='/opt/fifs/access.log'' fifs-1.0/fifs.sh
```

Создаём структуру каталогов для будущего пакета

```console
rpmdev-setuptree
```

Создаём архив с нашими файлами

```console
tar czvf rpmbuild/SOURCES/fifs-1.0.tar.gz fifs-1.0/
```

Для генерации болванки spec-файла переходим в каталог ~/rpmbuild/SPECS.

```console
rpmdev-newspec fifs
```

Пример получившегося spec-файла

```console
Name:           fifs
Version:        1.0
Release:        1%{?dist}
Summary:        Test RPM

License:        MIT
URL:            https://github.com/evlanoff/otus-linux/tree/master/module-1/rpms
Source0:        fifs-%{version}.tar.gz
BuildArch:      noarch

%description
Homework

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/opt/fifs
install fifs.sh $RPM_BUILD_ROOT/opt/fifs/fifs.sh
install access.log $RPM_BUILD_ROOT/opt/fifs/access.log

%clean
rm -rf $RPM_BUILD_ROOT

%post
echo -e "export PATH=$PATH:/opt/fifs" >> /etc/.profile
ln -s /opt/fifs/fifs.sh /usr/bin/fifs

%postun
rm -rf /opt/fifs

%files
%attr(0755,vagrant,vagrant) /opt/fifs/fifs.sh
%attr(0644,vagrant,vagrant) /opt/fifs/access.log
%doc

%changelog
```

Создаём RPM файл

```console
rpmbuild -bb rpmbuild/SPECS/fifs.spec
```

Если всё настроено правильно, то в директории rpmbuild/RPMS/noarch будет лежать rpm-пакет, который можно установить командой

```console
rpm -ivh rpmbuild/RPMS/noarch/fifs-1.0-1.el7.noarch.rpm
```

Пример использования

```console
fifs -h
```

Удалить пакет можно командой

```console
rpm -e fifs
```

# Настройка локального репозитория

Установка необходимых зависимостей для развёртывания репозитория

```console
yum install epel-release nginx createrepo -y
```

Подготовка пакетов для размещения в репозитории

```console
mkdir -p /usr/share/nginx/html/repo
cp fifs-1.0.noarch.rpm /usr/share/nginx/html/repo/
curl -o /usr/share/nginx/html/repo/nano-2.3.1-10.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/nano-2.3.1-10.el7.x86_64.rpm
createrepo /usr/share/nginx/html/repo/
```

Правим дефолтный конфиг веб-сервера


```console
#Указываем путь до папки, в которой будут лежать пакеты
sed -i '42d' /etc/nginx/nginx.conf
sed -i -e '42i\\     root     /usr/share/nginx/html/repo;' /etc/nginx/nginx.conf
#Автоиндексация каталога
sed -i -e '48i\\          autoindex on;' nginx.conf
```


Добавить в /etc/yum.repos.d

```console
cat >> /etc/yum.repos.d/otus-homework.repo << EOF
[otus-homework]
name=otus-homework
baseurl=http://localhost/
gpgcheck=0
enabled=1
EOF
```
Проверка, что репозиторий подключен

```console
yum repolist enabled | grep otus-homework
yum list | grep otus-homework
```

Запуск веб-сервера

```console
systemctl enable nginx
systemctl start nginx
systemctl status nginx
```
Заходим на ресурс

```console
w3m -N http://localhost/
```

Если всё правильно, в браузере будет список пакетов.
