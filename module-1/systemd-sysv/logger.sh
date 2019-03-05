#!/usr/bin/env bash

WORD=$1
LOG=$2


IF grep -i $WORD $LOG &> /dev/null
then
	logger "`grep -i $WORD $LOG | awk ' {print \"The root user last call: \", $3 }`"
else
	exit 0;
fi
