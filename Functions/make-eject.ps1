function make-eject {
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock {

$sh = New-Object -ComObject "Shell.Application"
$sh.Namespace(17).Items() | 
 Where-Object { $_.Type -eq "CD Drive" } | 
     foreach { $_.InvokeVerb("Eject") }
     }
}ELSE{Write-Host "Target:$($target.Name) is not online at this time."}} 
}