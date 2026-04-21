#!/usr/bin/env python3
#Check Package Changes

import os

#Header
print("===Checking Changes in Packages===")
print()

#Check if files exist
if not os.path.exists("before-package-list.txt"):
	print("ERROR: before-package-list.txt not found!")
	exit(1)
	
if not os.path.exists("package-list.txt"):
	print("ERROR: package-list.txt not found!")
	exit(1)

#Read Before 
with open("before-package-list.txt", "r") as f:
	before_lines = f.readlines()
	
#Read After
with open("package-list.txt", "r") as f:
	after_lines = f.readlines()
	
#Results
before = set(before_lines)
after = set(after_lines)
added = after - before
removed = before - after

for pkg in added:
	print(f"New: {pkg}")

for pkg in removed:
	print(f"Old: {pkg}")
	
print(f"Total new packages: {len(added)}")
print(f"Total removed packages: {len(removed)}")
	
#End
print()
print("Check Complete")