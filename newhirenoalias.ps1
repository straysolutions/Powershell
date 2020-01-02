#version 4

$firstname = Read-Host -Prompt 'First Name?'
$lastname = Read-Host -Prompt 'Last Name?'
$adname = Read-Host -Prompt 'Username?'
$title = Read-Host -Prompt 'Title?'
$phone = Read-Host -Prompt 'Phone number?'
$ext = Read-Host -Prompt 'Ext?'
$password = Read-Host "Enter password" -AsSecureString

#create AD User and mirror groupmembership from other user
New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@domain.local" -Path "OU=Horizon,OU=Local Users,DC=domain,DC=local" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -ScriptPath "login.bat" -Title "$title" -OfficePhone "$phone" -Office "$ext"
Get-ADUser -Identity $adname | Set-ADUser -Replace @{ipPhone="$phone"}
$CopyFromUser = Get-ADUser (Read-Host -Prompt 'Input the user name to copy group membership from') -prop MemberOf
$CopyToUser = $adname
$CopyFromUser.MemberOf | Where{$CopyToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $CopyToUser

#ask for dept to populate ad
function Show-Menu
{
     param (
           [string]$Title = 'Department???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for 010 - QA."
     Write-Host "2: Press '2' for 015 - IT."
     Write-Host "3: Press '3' for 016-Ware."
     Write-Host "4: Press '4' for 017-Maint."
     Write-Host "5: Press '5' for 020-Plant."
     Write-Host "6: Press '6' for 025-Sales."
     Write-Host "7: Press '7' for 070 - HR."
     Write-Host "8: Press '8' to 080-ACCT."
     Write-Host "9: Press '9' to 970-Clnt Serv."
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose option #1'
                Set-ADUser $adname -Department "010"
                
           } '2' {
                cls
                'You chose option #2'
                Set-ADUser $adname -Department "015"
           } '3' {
                cls
                'You chose option #3'
                Set-ADUser $adname -Department "016"
           } '4' {
                cls
                'You chose option #4'
                Set-ADUser $adname -Department "017"
           } '5' {
                cls
                'You chose option #5'
                Set-ADUser $adname -Department "020"
           } '6' {
                cls
                'You chose option #6'
                Set-ADUser $adname -Department "025"
           } '7' {
                cls
                'You chose option #7'
                Set-ADUser $adname -Department "070"
           } '8' {
                cls
                'You chose option #8'
                Set-ADUser $adname -Department "080" 
           } '9' {
                cls
                'You chose option #9'
                Set-ADUser $adname -Department "970"                  
                 
           } 'q' {
                return
           }
     }
     pause
}
until ($input)


#asks for address employee will be located
function Show-Menu
{
     param (
           [string]$Title = 'EMPLOYEE LOCATION???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for Horizon."
     Write-Host "2: Press '2' for East Texas Lighthouse."
     Write-Host "3: Press '3' for Warehouse."
     Write-Host "Q: Press 'Q' to quit."
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose option #1'
                Set-ADUser $adname -city "Tyler" -Country "US" -Postalcode "75702" -State "TX" -streetaddress "500 N Bois D'Arc" -EmailAddress "$adname@horizonind.com" -HomePage "www.horizonind.com" -Company "Hoizon"
                Add-Content "\\fileserv.domain.local\S\IT\TempDocs\emails.txt" ",$adname@horizonind.com"
           } '2' {
                cls
                'You chose option #2'
                Set-ADUser $adname -city "Tyler" -country "US" -Postalcode "75702" -State "TX" -streetaddress "411 W Front St" -EmailAddress "$adname@tylerlighthouse.org" -HomePage "www.tylerlighthouse.org" -Company "ETLB"
                Get-ADUser $adname | Move-ADObject -TargetPath "OU=Rehab,OU=Local Users,DC=domain,DC=local"
                Add-Content "\\fileserv.domain.local\S\IT\TempDocs\emails.txt" ",$adname@tylerlighthouse.org"
           } '3' {
                cls
                'You chose option #3'
                Set-ADUser $adname -city "Tyler" -country "US" -Postalcode "75702" -State "TX" -streetaddress "421 S Palace" -EmailAddress "$adname@horizonind.com" -HomePage "www.horizonind.com" -Company "Hoizon"
                Add-Content "\\fileserv.domain.local\S\IT\TempDocs\emails.txt" ",$adname@horizonind.com"
           } 'q' {
                return
           }
     }
     pause
}
until ($input)

#create H drive and assign user full control
New-Item “\\fileserv.domain.local\D$\H\$adname" –type directory
$Acl = Get-Acl "\\fileserv.domain.local\D$\H\$adname"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$adname","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "\\fileserv.domain.local\D$\H\$adname" $Acl

#create scan folder in H drive folder
New-Item “\\fileserv.domain.local\D$\H\$adname\Scans" –type directory
$Acl = Get-Acl "\\fileserv.domain.local\D$\H\$adname\Scans"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$adname","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "\\fileserv.domain.local\D$\H\$adname\Scans" $Acl

#log into Exhange Online
Write-Host "Logging into office 365 shell. Input office 365 creds"
$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

#asks location to creat user mailbox
function Show-Menu
{
     param (
           [string]$Title = 'Main Email???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for Horizon."
     Write-Host "2: Press '2' for East Texas Lighthouse."
     Write-Host "Q: Press 'Q' to quit."
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose option #1'
                New-MsolUser -DisplayName "$firstname $lastname" -FirstName $firstname -LastName $lastname -UserPrincipalName $adname@horizonind.com -UsageLocation US -LicenseAssignment "horizonindustries:ENTERPRISEPACK" -Password 'P@ssword01' -ForceChangePassword $True
           } '2' {
                cls
                'You chose option #2'
                New-MsolUser -DisplayName "$firstname $lastname" -FirstName $firstname -LastName $lastname -UserPrincipalName $adname@tylerlighthouse.org -UsageLocation US -LicenseAssignment "horizonindustries:ENTERPRISEPACK" -Password 'P@ssword01' -ForceChangePassword $True
           } 'q' {
                return
           }
     }
     pause
}
until ($input)
Read-Host -Prompt "Employee created press ENTER to exit."