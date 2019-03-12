#!/usr/bin/env bash

WORD=$1
LOG=$2
MESSAGE=`grep -i $WORD $LOG | awk ' {print "The root user last call: ", $3, "\n" } '`

if grep -i $WORD $LOG &> /dev/null
then
	logger "$MESSAGE"
else
	exit 0;
fi
