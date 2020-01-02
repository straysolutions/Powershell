#pops up a window with all computers in AD
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."

#installs product key to selected computer and activates it online
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Invoke-Command $($target.DNSHostName) -ScriptBlock {cscript.exe /nologo C:\Windows\System32\slmgr.vbs -ipk '6VQW2-64KG4-KT647-4XV2R-FVXDW'}}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Invoke-Command $($target.DNSHostName) -ScriptBlock {cscript.exe /nologo C:\Windows\System32\slmgr.vbs -ato}}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}}