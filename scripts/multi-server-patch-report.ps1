#Multi-Server Patch Report

#Header
Write-Host "===Multi-Server Patch Report==="
Write-Host ""

#Server Var
$Servers = @("SERVER-DC01", "localhost")

#Time Var
$Today = Get-Date -Format "yyyy-MM-dd"

#Check Servers for Last 5 Updates
foreach ($Server in $Servers) {
    try {
        $Updates = Get-HotFix -ComputerName $Server -ErrorAction Stop | Select-Object -Last 5
        Write-Host "Checking $Server"
        Write-Host "Last 5 installed updates:"
        $Updates | Format-Table -AutoSize HotFixID, Description, InstalledOn
        "=== $Server ===" | Out-File C:\serverreport-$Today.txt -Append
        $Updates | Out-File C:\serverreport-$Today.txt -Append
    } catch {
        Write-Host "Could not reach $Server" -ForegroundColor Red
    }
}

#End
Write-Host ""
Write-Host "Server Patch Report Complete"