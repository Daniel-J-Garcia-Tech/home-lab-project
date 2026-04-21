#!/usr/bin/env python3
#Pre-Patch Disk usage check

import shutil
from datetime import datetime

#Header
print("===Disk Usage Check===")
print()

#Var
today = datetime.now().strftime("%Y-%m-%d")
disks = ["/", "/home", "/tmp"]

#Check Disk - Print Usage
for disk in disks:
	usage = shutil.disk_usage(disk)
	percent_used = (usage.used / usage.total) * 100
	print(f"{disk} Disk Usage: {percent_used:.1f}%")
	with open(f"pre-patch-diskusage-check-{today}.txt", "a") as f:
		f.write(f"{disk} Disk Usage: {percent_used:.1f}%\n")
	if percent_used > 80:
		print(f"Warning - {disk}: Not safe to patch")
		with open(f"pre-patch-diskusage-check-{today}.txt", "a") as f:
			f.write(f"Warning - {disk}: Not safe to patch\n")
	else: 
		print(f"{disk}: Clear to patch")
		with open(f"pre-patch-diskusage-check-{today}.txt", "a") as f:
			f.write(f"{disk}: Clear to patch\n")
#End
print()
print("Disk Usage Check Complete")