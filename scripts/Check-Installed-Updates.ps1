# Installed Updates Report
# Purpose: Verify patch deployment

Write-Host "=== Installed Windows Updates ===" -ForegroundColor Cyan
Write-Host ""

# Get installed updates (last 10)
Write-Host "Last 10 installed updates:" -ForegroundColor Yellow
Get-HotFix | Select-Object -Last 10 | Format-Table -AutoSize HotFixID, Description, InstalledOn

Write-Host ""
Write-Host "Report complete!" -ForegroundColor Green