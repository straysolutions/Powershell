#this function will create an interactive window with out-gridview of all computers in AD. Select computer and click ok to get the OS version of the computer at the CLI

function get-osversion {

#pops up a window with all computers in AD
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."

#will display current os in powershell window
Write-Host "Target:$($target.DNSHostName)"
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Invoke-Command $($target.DNSHostName) -ScriptBlock {
Get-CimInstance Win32_Operatingsystem | select -expand Caption
}}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 
}