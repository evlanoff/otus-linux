**Найти IP-адрес из другого сегмента сети**

```console
#!/usr/bin/env bash

export ourlog='./access.log'

# l - full list of an IP
# s - subnet
# c - total count
# h - help

while getopts 'ls:ch' OPTION; do
    case "$OPTION" in
        l)
            awk '/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/ {print $1} ' $ourlog | sort -n | uniq
        ;;
        s)
            awk '/[0-9]*\.[0-9]*\.'"$OPTARG"'\.[0-9]*/ {print $1} ' $ourlog | sort -n | uniq
        ;;
        c)
            echo "Всего уникальных ip-адресов в журнале: " | tr -d "\n"
            awk '/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/ {print $1} ' $ourlog | sort -n | uniq | wc -l
        ;;
        h)
		echo -e "\n\tИспользование скрипта: $(basename $0) [-l] [-h] [-c] [-s somevalue]\n\n" >&2
		echo -e "\tКлюч -l выводит список всех IP-адресов в журнале.\n" >&2 echo "Использование скрипта: $(basename $0) [-l] [-h] [-c] [-s somevalue]" >&2
		echo -e "\tКлюч -s выводит список всех IP-адресов по заданной маске. Работает с третьим октетом.\n" >&2 exit 1
		echo -e "\t\tПример: $(basename $0) -s 77, напечатает список всех IP-адресов, 3 октет которых содержит 77.\n\n" >&2 ;;
		echo -e "\tКлюч -h печатает данную справку.\n\n" >&2
	esac
done
```

**watchdog скрипт с проверкой ip**

Например, к веб-серверу идёт обращение с IP-адреса первый октет которого начинается с 77. В этом случае нам необходимо отправить email со списком IP-адресов.

Для удобства составим расписание, которое будет выполняться каждую минуту с защитой от удаления журнала с IP-адресами.

```console
* * * * * /usr/bin/flock -w 0 /var/run/sendlog.lock /opt/sendlog.sh
```
(flock утилита для лока файла)

*Скрипт отправки лога на почту*

```console
#!/usr/bin/env bash

export ourlog=<path_to>/access.log
export alertlog=<path>/alert.log

if grep -q '^77' $ourlog; then
        awk '/^77/ {print $1}' $ourlog | sort | uniq -c > $alertlog
        mail -a $alertlog -s "Warning!" admin@localhost < /dev/null
else
        exit 1
fi
```
