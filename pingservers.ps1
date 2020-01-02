$computers = Get-ADComputer -Filter * -SearchBase "OU=Member Servers,DC=domain,DC=local" | Sort Name | Select -Expand DnsHostName
foreach ($item in $computers)
{
if (Test-Connection  -ComputerName $item -Quiet -Count 1)
{
    Write-Host "Computer:$item IS UP!!!" -foregroundcolor Green 
}
else
{
    Write-Host "!!!!!!Server $item not online!!!!!" -ForegroundColor Red  
}
}