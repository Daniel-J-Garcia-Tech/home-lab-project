#!/usr/bin/env python3
#Log File Scanner

import os
from datetime import datetime

#Header
print("===Checking Log File For Errors===")
print()

#Check if log exists
if not os.path.exists("test.log.txt"):
	print("ERROR: test.log.txt not found!")
	exit(1)

#Var
error = 0
failed = 0
warning = 0
today = datetime.now().strftime("%Y-%m-%d")

#Read Log
with open("test.log.txt", "r") as f:
	lines = f.readlines()

with open(f"logreport-{today}.txt", "w") as report:
	for line in lines:
		if "error" in line.lower():
			print("Found a Error!")
			error +=1
			report.write(f"Error Found: {line}\n")
		elif "failed" in line.lower():
			print("Found a Failure!")
			failed += 1
			report.write(f"Failure Found: {line}\n")
		elif "warning" in line.lower():
			print("Found a Warning!")
			warning +=1
			report.write(f"Warning Found: {line}\n")

print(f"Errors Found: {error}")
print(f"Failures Found: {failed}")
print(f"Warnings Found: {warning}")

with open(f"logreport-{today}.txt", "a") as report:
	report.write(f"Errors Found: {error}\n")
	report.write(f"Failures Found: {failed}\n")
	report.write(f"Warnings Found: {warning}\n")
	
#End
print()
print("Log File Checked")