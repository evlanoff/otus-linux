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
