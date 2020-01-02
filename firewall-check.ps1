 
$ComputerList = Get-ADComputer -Filter * | Sort Name | Select Name
$ScriptBlock = { @(netsh advfirewall show domain state)[3] -replace 'State' -replace '\s' }
 
foreach ($Computer in $ComputerList) {
    if (Test-Connection -ComputerName $Computer.Name -Quiet -Count 1) {
        try {
            $Status = Invoke-Command -ComputerName $Computer.Name -ErrorAction Stop -ScriptBlock $ScriptBlock
        }
        catch {
            $Status = "Unable to retrieve firewall status"
        }
    }
    else {
        $Status = "Unreachable"
    }
    $Object = [PSCustomObject]@{
        Computer = $Computer.Name
        Status = $Status
    }
 
    Write-Output $Object
    $Object | Export-Csv -Path "C:\Temp\FirewallStatus.csv" -Append -NoTypeInformation
 
}