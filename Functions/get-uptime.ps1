
function get-uptime {
#pops up a window with all computers in AD
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."

#will display current uptime in powershell window
Write-Host "Target:$($target.DNSHostName)"
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Invoke-Command $($target.DNSHostName) -ScriptBlock {
(Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName $target).LastBootupTime
}}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 
}