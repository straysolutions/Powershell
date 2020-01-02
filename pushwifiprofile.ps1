#uncommenting will clear computers list and populate with failed computers after first run 
#Clear-Content C:\Scripts\computers.txt
#Get-Content C:\Scripts\failed.txt | Set-Content C:\Scripts\computers.txt

#------Group of machines----------
$computers = Get-Content -Path c:\Scripts\computers.txt

foreach ($item in $computers)
{
if (Test-Connection  -ComputerName $item -Quiet -Count 1)
{
    Invoke-Command -ComputerName $item -ScriptBlock {
    $base64 = "PD94bWwgdmVyc2lvbj0iMS4wIj8+DQo8V0xBTlByb2ZpbGUgeG1sbnM9Imh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9uZXR3b3JraW5nL1dMQU4vcHJvZmlsZS92MSI+DQoJPG5hbWU+QWNjZXNzLVByaXZhdGUtUTM8L25hbWU+DQoJPFNTSURDb25maWc+DQoJCTxTU0lEPg0KCQkJPGhleD40MTYzNjM2NTczNzMyZDUwNzI2OTc2NjE3NDY1MmQ1MTMzPC9oZXg+DQoJCQk8bmFtZT5BY2Nlc3MtUHJpdmF0ZS1RMzwvbmFtZT4NCgkJPC9TU0lEPg0KCTwvU1NJRENvbmZpZz4NCgk8Y29ubmVjdGlvblR5cGU+RVNTPC9jb25uZWN0aW9uVHlwZT4NCgk8Y29ubmVjdGlvbk1vZGU+YXV0bzwvY29ubmVjdGlvbk1vZGU+DQoJPE1TTT4NCgkJPHNlY3VyaXR5Pg0KCQkJPGF1dGhFbmNyeXB0aW9uPg0KCQkJCTxhdXRoZW50aWNhdGlvbj5XUEEyUFNLPC9hdXRoZW50aWNhdGlvbj4NCgkJCQk8ZW5jcnlwdGlvbj5BRVM8L2VuY3J5cHRpb24+DQoJCQkJPHVzZU9uZVg+ZmFsc2U8L3VzZU9uZVg+DQoJCQk8L2F1dGhFbmNyeXB0aW9uPg0KCQkJPHNoYXJlZEtleT4NCgkJCQk8a2V5VHlwZT5wYXNzUGhyYXNlPC9rZXlUeXBlPg0KCQkJCTxwcm90ZWN0ZWQ+ZmFsc2U8L3Byb3RlY3RlZD4NCgkJCQk8a2V5TWF0ZXJpYWw+QklHT0xidXp6a2lsbDwva2V5TWF0ZXJpYWw+DQoJCQk8L3NoYXJlZEtleT4NCgkJPC9zZWN1cml0eT4NCgk8L01TTT4NCgk8TWFjUmFuZG9taXphdGlvbiB4bWxucz0iaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL25ldHdvcmtpbmcvV0xBTi9wcm9maWxlL3YzIj4NCgkJPGVuYWJsZVJhbmRvbWl6YXRpb24+ZmFsc2U8L2VuYWJsZVJhbmRvbWl6YXRpb24+DQoJPC9NYWNSYW5kb21pemF0aW9uPg0KPC9XTEFOUHJvZmlsZT4NCg==
"
$dir = "C:\Temp"
if(!(Test-Path -Path $dir )){
    New-Item -Path $dir -Type directory}

$Content = [System.Convert]::FromBase64String($Base64)
Set-Content -Path C:\Temp\WifiProfile.xml -Value $Content -Encoding Byte

netsh wlan add profile filename=C:\Temp\WifiProfile.xml

Remove-Item C:\Temp\WifiProfile.xml}

    Write-Host "Computer:$item Has new profile!!!" -foregroundcolor Green
    
}
else
{
    Write-Host "Host $item no pingie! `n" -ForegroundColor Red
    Add-Content c:\Scripts\failed.txt $item 
}
}