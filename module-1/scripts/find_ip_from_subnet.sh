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
            echo -e "\tКлюч -l выводит список всех IP-адресов в журнале.\n" >&2
            echo -e "\tКлюч -s выводит список всех IP-адресов по заданной маске. Работает с третьим октетом.\n" >&2
            echo -e "\t\tПример: $(basename $0) -s 77, напечатает список всех IP-адресов, 3 октет которых содержит 77.\n\n" >&2
            echo -e "\tКлюч -h печатает данную справку.\n\n" >&2
	    exit 1
        ;;
    esac
done
