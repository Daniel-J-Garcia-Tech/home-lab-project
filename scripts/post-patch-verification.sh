#!/bin/bash
#Post-Patch Verification

#Header
echo "===Post-Patch Verification==="
echo ""

#Pass/Fail
fail=0

#Hostname/Date-Time
today=$(date +%Y-%m-%d)
echo "Hostname: $(hostname)"
echo "Hostname: $(hostname)" > postpatch-report-$today.txt
echo "Date & Time: $(date)"
echo "Date & Time: $(date)" >> postpatch-report-$today.txt

#Disk Usage
usage=$(df / --output=pcent | tail -1 | tr -d ' %')
if [ $usage -gt 80 ]; then
	echo "WARNING: Disk Usage above 80%"
	echo "WARNING: Disk Usage above 80%" >> postpatch-report-$today.txt
	fail=$((fail +1))
else
	echo "Disk Usage: $usage"
	echo "Disk Usage: $usage" >> postpatch-report-$today.txt
fi

#Check Critical Services
services=("ssh" "cron")
for service in "${services[@]}"; do
	if systemctl is-active --quiet $service; then
		echo "$service is active"
		echo "$service is active" >> postpatch-report-$today.txt
	else 
		echo "$service is inactive"
		echo "$service is inactive" >> postpatch-report-$today.txt
		fail=$((fail +1))
	fi
done

#Count Packages
echo "Package Count: $(dpkg -l | grep "^ii" | wc -l)"
echo "Package Count: $(dpkg -l | grep "^ii" | wc -l)" >> postpatch-report-$today.txt

#Final Verdict
if [ $fail -gt 0 ]; then
	echo "Post-Patch Verification Failed"
	echo "Post-Patch Verification Failed" >> postpatch-report-$today.txt
else
	echo "Post-Patch Verification Passed"
	echo "Post-Patch Verification Passed" >> postpatch-report-$today.txt
fi

#End
echo ""
echo "Check Complete"