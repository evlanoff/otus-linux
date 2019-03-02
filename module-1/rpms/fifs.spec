Name:           fifs
Version:        1.0
Release:        1%{?dist}
Summary:        Тестовый RPM-пакет для выполнения ДЗ

License:        MIT
URL:            https://github.com/evlanoff/otus-linux/module-1/scripts
Source0:        fifs-%{version}.tar.gz
BuildArch:      noarch

%description
Примитивный анализатор журнала

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/opt/fifs
install fifs.sh $RPM_BUILD_ROOT/opt/fifs/fifs.sh
install access.log $RPM_BUILD_ROOT/opt/fifs/access.log

%post
echo -e "export PATH=$PATH:/opt/fifs" >> /etc/.profile
ln -s /opt/fifs/fifs.sh /usr/bin/fifs

%postun
rm -rf /opt/fifs

%clean
rm -rf $RPM_BUILD_ROOT

%files
%attr(0755,vagrant,vagrant) /opt/fifs/fifs.sh
%attr(0644,vagrant,vagrant) /opt/fifs/access.log
%doc

%changelog
