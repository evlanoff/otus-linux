#!/usr/bin/env python

import psutil
import os
import sys

print "PID\tTTY\t\tSTAT\t\tTIME\tCOMMAND"
for i in psutil.pids():
	print psutil.Process(i).pid, "\t", os.ttyname(sys.stdout.fileno()), "\t", psutil.Process(i).status(), "\t", psutil.Process(i).cpu_percent(), "\t", psutil.Process(i).exe()
