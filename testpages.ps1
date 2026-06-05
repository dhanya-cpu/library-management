$adminSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginBody = "username=admin&password=admin123"
$r = Invoke-WebRequest -Uri "http://localhost:8080/library-management/login" -Method POST -Body $loginBody -UseBasicParsing -TimeoutSec 10 -WebSession $adminSession -MaximumRedirection 5
Write-Host "Admin login: $($r.StatusCode) - $(if($r.Content -match 'stat-card|Dashboard|totalBooks') {'Dashboard LOADED'} else {'FAILED'})"

$adminPages = @("admin/dashboard","admin/books","admin/members","admin/issue","admin/fines","admin/reports")
foreach ($p in $adminPages) {
    try {
        $r2 = Invoke-WebRequest -Uri "http://localhost:8080/library-management/$p" -UseBasicParsing -TimeoutSec 8 -WebSession $adminSession
        $ok = if ($r2.StatusCode -eq 200 -and $r2.Content.Length -gt 500) {"OK ($($r2.Content.Length) bytes)"} else {"SMALL RESPONSE"}
        Write-Host "$p -> $ok"
    } catch {
        Write-Host "$p -> ERROR: $_"
    }
}
