#!/usr/bin/env bash

for i in `ls -d [0-9]* /proc/`; do
	echo $i
done
