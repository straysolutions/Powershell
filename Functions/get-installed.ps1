#***WARNING THIS FUNCTION RELIES ON YOU HAVING THE GET-SOFTWARE FUNCTION LOADED***
#this function lists all computers on domain and will get a list of installed software. 
function get-installed {
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock ${Function:get-software}
     }
}ELSE{Write-Host "Target:$($target.Name) is not online at this time."}
}