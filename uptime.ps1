$computer = Read-Host -Prompt 'Computer Name?'
(Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName $computer).LastBootupTime