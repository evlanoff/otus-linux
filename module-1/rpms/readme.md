# Создание RPM пакета

Устанавливаем необходимые зависимости. (Сделать provisioning в Vagrantfile)

```console
yum install -y epel-release
yum install -y vim rpmdevtools rpm-build
```

Скачиваем в директорию файлы, которые будут упакованы в пакет.

```console
mkdir fifs-1.0
curl -O https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/find_ip_from_subnet.sh
curl -O https://raw.githubusercontent.com/evlanoff/otus-linux/master/module-1/scripts/access.log
mv find_ip_from_subnet.sh fifs.sh
```

Создаём структуру каталогов для будущего пакета

```console
rpmdev-setuptree
```
Создаём архив с нашими файлами

```console
tar czvf rpmbuild/SOURCES/fifs-1.0.tar.gz fifs-1.0/
```

Для генерации болванки spec-файла переходим в папку ~/rpmbuild/SPECS, где созаём spec-файл.

```console
rpmdev-newspec fifs
```

Редактируем вновь созданный spec-файл

```console
vim fifs.spec
```

Пример получившегося spec-файла

```console
Name:           fifs
Version:        1.0
Release:        1%{?dist}
Summary:        Test RPM

License:        MIT
URL:            https://github.com/evlanoff/otus-linux
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

%files
/opt/fifs/fifs.sh
/opt/fifs/access.log
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

Удалить пакет можно командой

```console
rpm -e fifs
```

# Настройка локального репозитория

Установка необходимых зависимостей для развёртывания репозитория

```console
yum install nginx createrepo w3m -y
```

Подготовка пакетов для размещения в репозитории

```console
mkdir -p /usr/share/nginx/html/repo
cp fifs-1.0.noarch.rpm /usr/share/nginx/html/repo/
curl -o /usr/share/nginx/html/repo/nano-2.3.1-10.el7.src.rpm http://vault.centos.org/7.5.1804/os/Source/SPackages/nano-2.3.1-10.el7.src.rpm
createrepo /usr/share/nginx/html/repo/
```

Правим дефолтный конфиг веб-сервера

```console
vi /etc/nginx/nginx.conf

server {
...
#Указываем путь до папки, в которой будут лежать пакеты
	root /usr/share/nginx/html/repo;
...
location / {
	autoindex on;
}
...
}
```

```console
sed -i -e '49i\\          autoindex on;' nginx.conf
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