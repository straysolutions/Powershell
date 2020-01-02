#adds all RSAT tools 
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Name RSAT* –Online