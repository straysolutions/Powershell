

$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock {
$netpath = "C:\Program Files (x86)\SonicWall\SSL-VPN\NetExtender"
$batpath = "C:\Program Files (x86)\SonicWall\SSL-VPN\NetExtender\NxConnect.bat"
$ScriptLine ="@ECHO OFF
Title Please wait...
ECHO Reconfiguring mapped drives for VPN access.
POWERSHELL -ExecutionPolicy Bypass -File \\FILESERV.DOMAIN.LOCAL\RES$\VPNMAP.ps1"


if(!(Test-Path $netpath -PathType Container)) { 
    write-host "-- Path not found"
} else {
    write-host "-- Path found"
    
Set-Content -Path $batpath -Value $ScriptLine -Encoding ASCII -force
}
     }
     }
}ELSE{Write-Host "Target:$($target.Name) is not online at this time."}