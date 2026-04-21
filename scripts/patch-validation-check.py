#!/usr/bin/env python3
#Patch Validation Check

import subprocess

#Header
print("===Patch Validation Check===")
print()

#Get/Check list of installed packages
print("Getting installed packages...")
result = subprocess.run(['dpkg', '-l'], capture_output=True, text=True)
if result.returncode !=0:
	print("ERROR: dpkg command failed")
	exit(1)

#Filter for installed packages (ii)
lines = result.stdout.split('\n')
packages = [line for line in lines if len(line) > 0 and line[0:2] == 'ii']

#Write package list to file
print("Writing package list to file")
with open("package-list.txt", "w") as f:
	for pkg in packages:
		parts = pkg.split()
		if len(parts) >= 3:
			name = parts[1]
			version = parts[2]
			f.write(f"{name} {version}\n")
total = len(packages)
print(f"Total Package saved: {total}")

print()
print("Report File Created")