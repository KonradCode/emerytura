# Parametry
$url = "https://github.com/KonradCode/emerytura/releases/download/2/emka.exe"
$destination = "C:\DeployedApps\emka.exe"

# Pobierz plik z GitHub Releases
Write-Host "Pobieranie pliku emka.exe z GitHub..."
Invoke-WebRequest -Uri $url -OutFile $destination

# Uruchom aplikację (opcjonalnie)
Write-Host "Uruchamianie aplikacji..."
Start-Process -FilePath $destination -NoNewWindow
