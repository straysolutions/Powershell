$computers = Get-Content 'C:\scripts\computers.txt'

foreach ($computer in $computers)
{

Restart-Computer -ComputerName $computer -force

}