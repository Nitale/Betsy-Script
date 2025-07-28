$zipUrl = "https://github.com/Nitale/Betsy-Script/heads/main.zip"

Invoke-WebRequest $zipUrl -OutFile "temp.zip"
Expand-Archive "temp.zip" -DestinationPath "temp" -Force
Copy-Item "temp\*" -Destination "." -Recurse -Force
Remove-Item "temp.zip", "temp" -Recurse -Force