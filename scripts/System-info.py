#!/usr/bin/env python3
# System Information Script

import os
import platform
import subprocess

print("=== System Information===")
print()

# Hostname
hostname = platform.node()
print(f"Hostname: {hostname}")

# OS Information
os_name = platform.system()
os_version =  platform.release()
print(f"OS: {os_name} {os_version}")

# Python version
python_version = platform.python_version()
print(f"Python: {python_version}")

# Uptime
uptime = subprocess.check_output(['uptime', '-p']).decode('utf-8').strip()
print(f"Uptime: {uptime}")

print()
print("Script complete!")