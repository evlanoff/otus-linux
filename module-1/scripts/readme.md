##Найти IP-адрес из другого сегмента сети

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
            awk '/[0-9]*\.[0-9]*\.[0-9]\.[0-9]*/ {print $1} ' $ourlog | uniq | sort -n
        ;;
        s)
            awk '/[0-9]*\.[0-9]*\.'"$OPTARG"'\.[0-9]*/ {print $1} ' $ourlog | uniq | sort -n
        ;;
        c)
            echo "Всего уникальных ip-адресов в журнале: " | tr -d "\n"
            awk '/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/ {print $1} ' $ourlog | uniq | wc -l
        ;;
        h)
            echo "Использование скрипта: $(basename $0) [-l] [-h] [-c] [-s somevalue]" >&2
            exit 1
        ;;
    esac
done
```

##watchdog скрипт с проверкой ip

Например, к веб-серверу идёт обращение с IP-адреса первый октет которого начинается с 77.

```console
#!/usr/bin/env bash
awk '/^77/ {print $1} ' $ourlog | uniq | sort -n
```

Нам по каким-то причинам не нужно их учитывать

*Доделать алгоритм*

Если обращение идёт с 77, то удалять их из журнала и отправить (письмо с вложением некого журнала?) сообщение, иначе ждать некоторое время. Возможно привязать к частоте выполнения крон задачи?.

if ( awk '/^77/ {print $1} ' $ourlog | uniq | sort -n ) 2> /dev/null; #Условие должно быть истинным и только 1 IP-адрес?
    then
        trap 'sed -i "/^77/"' INT TERM EXIT KILL
            mail -s "Журнал очищен" root@localhost
        trap - INT TERM EXIT
else
    sleep 10s