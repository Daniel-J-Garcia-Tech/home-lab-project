# Installed Updates Report
# Purpose: Verify patch deployment

Write-Host "=== Installed Windows Updates ===" -ForegroundColor Cyan
Write-Host ""

#Computer Name & Date/Time
$Today = Get-Date -Format "yyyy-MM-dd"
Write-Host "Computer Name: $env:COMPUTERNAME" -ForegroundColor Green
"Computer Name: $env:COMPUTERNAME" | Out-File C:\report-$Today.txt
Write-Host "Current Date & Time: $(Get-Date)" -ForegroundColor Green
"Current Date & Time: $(Get-Date)" | Out-File C:\report-$Today.txt -Append


# Get installed updates (last 10)
try {
    $Update = Get-HotFix -ErrorAction Stop | Select-Object -Last 10
    Write-Host "Last 10 installed updates:" -ForegroundColor Yellow
    $Update | Format-Table -AutoSize HotFixID, Description, InstalledOn
    $Update | Out-File C:\report-$Today.txt -Append
} catch {
    Write-Host "ERROR: Could not retrieve updates" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Report complete!" -ForegroundColor Green