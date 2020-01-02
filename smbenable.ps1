#------Group of machines----------
$computers = Get-Content -Path 'c:\Scripts\computers.txt'
foreach ($item in $computers)
{
if (Test-Connection  -ComputerName $item -Quiet -Count 1)
{
    Write-Host "Computer:$item SMB Enabled!!!" -foregroundcolor Green
    Invoke-Command {Set-Service LANMANServer -startupType manual} -ComputerName $item
    Invoke-Command {start-service LANMANServer} -ComputerName $item
    Invoke-Command {Set-Service Browser -startupType manual} -ComputerName $item
    Invoke-Command {start-service Browser} -ComputerName $item
}
else
{
    Write-Host "Host $item no pingie! `n" -ForegroundColor Red  
}
}
