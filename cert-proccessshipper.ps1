

$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock {
cls

Write "Installing cert..."
#installs cert 
$var = @'
##paste cert here

'@

$Content = [System.Convert]::FromBase64String($var)
Set-Content -Path C:\Temp\processshipper.crt -Value $Content -Encoding Byte
Get-Command -Module PKIClient;
certutil -addstore "Root" C:\Temp\processshipper.crt
}

     }

ELSE{Write-Host "Target:$($target.Name) is not online at this time."}}
