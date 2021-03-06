﻿function sesh {
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Enter-PSSession $($target.DNSHostName)}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 
}