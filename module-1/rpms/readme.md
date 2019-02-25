**Создание RPM пакета**

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