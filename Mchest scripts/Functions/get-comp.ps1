#custom function to get the Computer Name, Last Logon time, ipaddress, LAPS, and OS from a computer

function get-comp {

#pops up a window with all computers in AD. Select 1 or more computers
$comps = Invoke-Command -ComputerName ad-1.mchest.net -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT -ExpandProperty Name
$target = $comps | Out-GridView -PassThru -Title  "Select workstation name."
#fires command for each computer and displays results in outgrid
$results = foreach($item in $target)
{
Get-ADComputer -identity $item -Properties * | Select-Object Name, LastLogonDate, IPv4Address, OperatingSystem
}

$results | out-gridview
}