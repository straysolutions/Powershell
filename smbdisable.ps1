#------Group of machines----------
$computers = Get-Content -Path 'c:\Scripts\computers.txt'
foreach ($item in $computers)
{
if (Test-Connection  -ComputerName $item -Quiet -Count 1)
{
    Write-Host "Computer:$item SMB Disabled!!!" -foregroundcolor Green
    Invoke-Command {stop-service Browser} -ComputerName $item
    Invoke-Command {Set-Service Browser -startupType disabled} -ComputerName $item
    Invoke-Command {stop-service LANMANServer} -ComputerName $item
    Invoke-Command {Set-Service LANMANServer -startupType disabled} -ComputerName $item
}
else
{
    Write-Host "Host $item no pingie! `n" -ForegroundColor Red  
}
}
