param
(
 $Computer
)
$colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $Computer | Where{$_.IpEnabled -Match "True"}  
foreach ($objItem in $colItems)
{
     $objItem | select Description,MACAddress  
}