#Service Recovery After Patching

#Header
Write-Host "===Service Recovery Check==="
Write-Host ""

#Service/Time Var
$Today = Get-Date -Format "yyyy-MM-dd"
$Services = @("wuauserv", "W32Time", "Spooler")

#Check/Start Services
foreach($Service in $Services) {
    try {
        $ServiceStatus = Get-Service $Service -ErrorAction Stop
        if ($ServiceStatus.Status -eq "Running") {
            Write-Host "$Service - Running" -ForegroundColor Green
            "$Service - Running" | Out-File C:\servicereport-$Today.txt -Append
        } else {
            Start-Service -Name $Service -ErrorAction Stop
            Write-Host "$Service - Started" -ForegroundColor Yellow
            "$Service - Started" | Out-File C:\servicereport-$Today.txt -Append
        }
    } catch {
        Write-Host "Could not start $Service" -ForegroundColor Red
        "Could not start $Service" | Out-File C:\servicereport-$Today.txt -Append
    }
}
#End
Write-Host ""
Write-Host "Service Check Complete"