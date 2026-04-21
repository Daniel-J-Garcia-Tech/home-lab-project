#Running Services Check

Write-Host "===Running Services Check===" -ForegroundColor Cyan
Write-Host ""

#Computer Name & Date/Time
Write-Host "Computer Name: $env:COMPUTERNAME" -ForegroundColor Green
Write-Host "Current Date & Time: $(Get-Date)" -ForegroundColor Green

#Total Running Services Count / Output File
$Today = Get-Date -Format "yyyy-MM-dd"
try {
    $RunningServices = Get-Service -ErrorAction Stop | Where-Object {$_.Status -eq "Running"}
    Write-Host "Total Running: $($RunningServices.Count)" -ForegroundColor Green
    $RunningServices | Out-File C:\Scripts\runningservices-$Today.txt
} catch {
    Write-Host "ERROR: Could not retrieve services" -ForegroundColor Red
    exit
}

#End
Write-Host ""
Write-Host "Running Services Check Complete" -ForegroundColor Cyan