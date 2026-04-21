#!/bin/bash
#Bash Package Checker

#Header
echo "===Package Checker==="
echo ""

#Hostname/Date-Time
today=$(date +%Y-%m-%d)
echo "Hostname: $(hostname)"
echo "Hostname: $(hostname)" > report-$today.txt
echo "Date & Time: $(date)"
echo "Date & Time: $(date)" >> report-$today.txt

#Check Critical Packages
pass=0
fail=0
packages=("openssh-server" "curl" "vim" "fake-package")
for pkg in "${packages[@]}"; do
	if dpkg -l $pkg > /dev/null 2>&1; then
		echo "$pkg - Installed"
		echo "$pkg - Installed" >> report-$today.txt
		pass=$((pass + 1))
	else
		echo "$pkg - Not Found"
		echo "$pkg - Not Found" >> report-$today.txt
		fail=$((fail + 1))
	fi
done
echo "Installed: $pass"
echo "Installed: $pass" >> report-$today.txt
echo "Not Found: $fail"
echo "Not Found: $fail" >> report-$today.txt

#End
echo "Check Complete"
echo ""