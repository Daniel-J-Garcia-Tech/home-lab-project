#!/usr/bin/env python3
#Critical Package Check

#import
import subprocess
from datetime import datetime

#Header
print("===Package Information===")
print()

#Vars
packages = ["openssh-server", "curl", "vim", "fake-package"]
today = datetime.now().strftime("%Y-%m-%d")
passed = 0
failed = 0

#Package Check/Write
for pkg in packages:
	result = subprocess.run(["dpkg", "-l", pkg], capture_output=True, text=True)
	if result.returncode == 0:
		print(f"{pkg} - INSTALLED")
		passed += 1
		with open(f"packagecheckreport-{today}.txt", "a") as f:
			f.write(f"{pkg} - INSTALLED\n")
	else:
		print(f"{pkg} - NOT FOUND")
		failed += 1
		with open(f"packagecheckreport-{today}.txt", "a") as f:
			f.write(f"{pkg} - NOT FOUND\n")

#Write/Print passed/failed
print(f"Installed: {passed}")
print(f"Not Found: {failed}")
with open(f"packagecheckreport-{today}.txt", "a") as f:		
	f.write(f"Installed: {passed}\n")
	f.write(f"Not Found: {failed}\n")
	
#End
print()
print("Check Complete")