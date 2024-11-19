# Parametry
$remoteServer = "192.168.1.100"
$remotePath = "C:\DeployedApps"
$appName = "emka.exe"

# Pobierz aplikację z serwera
Write-Host "Przesyłanie aplikacji na serwer..."
Copy-Item -Path .\$appName -Destination "\\$remoteServer\$remotePath" -Force

# Uruchom aplikację
Write-Host "Uruchamianie aplikacji..."
Invoke-Command -ComputerName $remoteServer -ScriptBlock {
    Start-Process -FilePath "C:\DeployedApps\emka.exe" -NoNewWindow
}
