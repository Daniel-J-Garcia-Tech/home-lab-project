#!/bin/bash
#System Snapshot

#Header
echo "===System Snapshot==="
echo ""

#Report Date Var
today=$(date +%Y-%m-%d)
#Hostname
echo "Hostname: $(hostname)"
echo "Hostname: $(hostname)" > report-$today.txt

#Date-Time
echo "Date & Time: $(date)"
echo "Date & Time: $(date)" >> report-$today.txt

#Kernel
echo "Kernel: $(uname -r)"
echo "Kernel: $(uname -r)" >>report-$today.txt

#Packages count
echo "Package Count: $(dpkg -l | grep "^ii" | wc -l)"
echo "Package Count: $(dpkg -l | grep "^ii" | wc -l)" >> report-$today.txt

#End
echo "Snapshot Complete"
echo ""