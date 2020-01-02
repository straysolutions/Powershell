$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){
$session = New-PSSession $($target.DNSHostName)
Import-PSSession $session
Start-Sleep -s 5

cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
New-Item -Path . -Name "rick.bat" -ItemType "file" -Value '@echo off
timeout 3
start https://www.youtube.com/watch?v=dQw4w9WgXcQ
(goto) 2>nul & del "%~f0"'

}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 



