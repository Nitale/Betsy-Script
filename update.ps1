$zipUrl = "https://github.com/Nitale/Betsy-Script/archive/refs/heads/main.zip"

try {
    Invoke-WebRequest $zipUrl -OutFile "temp.zip"
    Expand-Archive "temp.zip" -DestinationPath "temp" -Force
    $extracted = Get-ChildItem "temp" | Select-Object -First 1
    Copy-Item "$($extracted.FullName)\*" -Destination "." -Recurse -Force
    Remove-Item "temp.zip", "temp" -Recurse -Force
} catch {
    Write-Host $_.Exception.Message
    if (Test-Path "temp.zip") { Remove-Item "temp.zip" -Force }
    if (Test-Path "temp") { Remove-Item "temp" -Recurse -Force }
}