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
