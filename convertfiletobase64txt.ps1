$Content = Get-Content -Path "C:\Temp\WifiProfile.xml" -Encoding Byte
$Base64 = [System.Convert]::ToBase64String($Content)
$Base64 | Out-File "C:\Temp\WifiProfile.txt"