function get-lockoutinfo {

$ErrorActionPreference = "SilentlyContinue"
Clear-Host
$User = Read-Host -Prompt "Please enter a user name"
#Locate the PDC
$PDC = (Get-ADDomainController -Discover -Service PrimaryDC).Name
#Locate all DCs
$DCs = (Get-ADDomainController -Filter *).Name #| Select-Object name
foreach ($DC in $DCs) {
Write-Host -ForegroundColor Green "Checking events on $dc for User: $user"
    if ($DC -eq $PDC) {
        Write-Host -ForegroundColor Green "$DC is the PDC"
        }
    Get-WinEvent -ComputerName $DC -Logname Security -FilterXPath "*[System[EventID=4740 or EventID=4625 or EventID=4770 or EventID=4771 and TimeCreated[timediff(@SystemTime) <= 3600000]] and EventData[Data[@Name='TargetUserName']='$User']]" | Select-Object TimeCreated,@{Name='User Name';Expression={$_.Properties[0].Value}},@{Name='Source Host';Expression={$_.Properties[1].Value}} -ErrorAction SilentlyContinue
    }
    }