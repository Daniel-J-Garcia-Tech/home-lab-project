#!/usr/bin/env python3
# Check Installed Packages Script

import subprocess

print("=== Installed Packages Report ===")
print()

# Get list of installed packages
print("Getting installed packages...")
result = subprocess.run(['dpkg', '-l'], capture_output=True, text=True)

# Filter for installed packages (lines starting with 'ii ')
lines = result.stdout.split('\n')
packages = [line for line in lines if len(line) > 0 and line[0:2] == 'ii']

total = len(packages)
print(f"Total packages installed: {total}")
print()

# Show last 10 installed packages
print("Last 10 installed packages:")
print("-" * 50)
	for pkg in packages[-10:]:
	parts = pkg.split()
	if len(parts) >= 3:
		name = parts[1]
		version = parts[2]
		print(f"{name:30} {version}")
		
print()
print("Report complete!")