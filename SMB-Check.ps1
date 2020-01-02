$stats = @()
$workstations = Get-ADComputer -Filter * | Sort Name | Select -Expand DnsHostName
$workstations | %{
                    #create the object
                    $workstation = [PSCustomObject]@{
                                    WorkStation = $_
                                    State = ""
                                    Browser = ""
                                    Server = ""
                    } 
                    #test the conneciton
                    if(Test-Connection -ComputerName $_ -Quiet -Count 1){
                        Write-Host "Computer $_ is up, testing services." -ForegroundColor Green
                         $workstation.State = "Up"
                         #Do your check/actions here, populate the other properties with the data gleaned.
                         $state = $(Invoke-Command -ComputerName $_ {$(Get-Service LanManServer).Status}).value
                         $workstation.Server = if($state -eq "Stopped"){"Service is currently stopped."}else{"Service is in state:$state"}
                         $state = $(Invoke-Command -ComputerName $_ {$(Get-Service Browser).Status}).value
                         $workstation.Browser = if($state -eq "Stopped"){"Service is currently stopped."}else{"Service is in state:$state"}
                    } else {
                        Write-Host "Computer $_ is down, logging and proceeding." -ForegroundColor Red
                         $workstation.State = "Down"
                    }
    #add the workstation to the final collection
    $stats += $workstation
}
$stats | Export-Csv -Path "C:\Temp\SMBStatus.csv" -Append -NoTypeInformation 
