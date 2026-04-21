#!/usr/bin/env python3
# System Information Script

import os
import platform
import subprocess
from datetime import datetime

#Header
print("=== System Information===")
print()

#Time Var
today = datetime.now().strftime("%Y-%m-%d")
#Hostname
hostname = platform.node()
print(f"Hostname: {hostname}")
with open(f"systeminforeport-{today}.txt", "a") as f:
	f.write(f"Hostname: {hostname}\n")

#OS Information
os_name = platform.system()
os_version =  platform.release()
print(f"OS: {os_name} {os_version}")
with open(f"systeminforeport-{today}.txt", "a") as f:
	f.write(f"OS: {os_name} {os_version}\n")

#Python version
python_version = platform.python_version()
print(f"Python: {python_version}")
with open(f"systeminforeport-{today}.txt", "a") as f:
	f.write(f"Python: {python_version}\n")

#Uptime
try:
	uptime = subprocess.check_output(['uptime', '-p']).decode('utf-8').strip()
	print(f"Uptime: {uptime}")
	with open (f"systeminforeport-{today}.txt", "a") as f:
			f.write(f"Uptime: {uptime}\n")
except:
	print("ERROR: Uptime command failed")

#End
print()
print("Script complete!")