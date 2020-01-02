#This script will disable AD account, export group membership to a csv, ask to delete hdrive/scan folder, connect to Exchange online, export email group memgership to a csv
# convert users mailbox to a shared mailbox, add a user to that shared mailbox, and remove the O365 license
#version 4

#disables ad account
$User = Read-Host -Prompt 'Input the user name to disable'
Disable-ADAccount $User
Write-Host "Account DISABLED" -ForegroundColor Green

#export AD Group Membership to CSV and remove group memberhsip
Get-ADPrincipalGroupMembership $User | select name | Export-Csv \\fileserv.domain.local\S\IT\TempDocs\ADgroupmembership.csv
Write-Host "***AD Group MEmbership output to \\fileserv.domain.local\S\IT\TempDocs***" -ForegroundColor Green
Get-ADUser -Identity $User -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
}

#displays scan folder contents and asks if you want to delete the users scans folder on h drive
function Show-Menu
{
     param (
           [string]$Title = '***WARNING*** WOULD YOU LIKE TO DELETE THE USERS SCANS FOLDER ON THE H DRIVE???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to skip."
     Write-Host "9: Press '9' TO DELETE SCNAS FOLDER ON H DRIVE."
     Write-Host "Q: Press 'Q' to quit."
     get-childitem "\\fileserv.domain.local\h\$adname\Scans"
}
do
{

     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose option #1 to skip'
                continue
 
           } '9' {
                cls
                'You chose option #9 to delete the scans folder on the H drive. Hope you were sure...'
                Remove-Item "\\fileserv.domain.local\h\$adname\Scans" -Force -Recurse
           } 'q' {
                continue
           }
     }
     pause
}
until ($input)

#displays h drive contents and asks if you want to delete
function Show-Menu
{
     param (
           [string]$Title = '***WARNING*** WOULD YOU LIKE TO DELETE THE USERS H DRIVE???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to skip."
     Write-Host "9: Press '9' TO DELETE USERS H DRIVE."
     Write-Host "Q: Press 'Q' to quit."
     get-childitem "\\fileserv.domain.local\h\$adname"
}
do
{

     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose option #1 to skip'
                continue
 
           } '9' {
                cls
                'You chose option #9 to delete the users H drive. Hope you were sure...'
                Remove-Item "\\fileserv.domain.local\h\$adname" -Force -Recurse
           } 'q' {
                continue
           }
     }
     pause
}
until ($input)

#removes email from emails.txt on \\fileserv\s\it\tempdocs
(Get-Content "\\fileserv.domain.local\S\IT\TempDocs\emails.txt") -notmatch "$User" | Out-File "\\fileserv.domain.local\S\IT\TempDocs\emails.txt"

#log into Exhange Online
Write-Host "***Input O365 creds to login***" -ForegroundColor Green
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Export Email Group Membership and remove from all groups
$email = Read-Host -Prompt 'Input email to convert to shared mailbox and remove license'
$Mailbox=get-Mailbox "$email"
$DN=$mailbox.DistinguishedName
$Filter = "Members -like ""$DN"""
Get-DistributionGroup -ResultSize Unlimited -Filter $Filter | Select-Object Name,DisplayName,GroupType,PrimarySmtpAddress | export-csv \\fileserv.domain.local\S\IT\TempDocs\emailgroupmembership.csv
Write-Host "***Email Group Membership output to \\fileserv.domain.local\S\IT\TempDocs\***" -ForegroundColor Green
foreach ($group in Get-DistributionGroup -ResultSize unlimited) {
 if ((Get-DistributionGroupMember $group.identity | select -Expand distinguishedname) -contains $DN){
  write-host "Removing user from" $group.name
  Remove-DistributionGroupMember $group.name -member $DN -BypassSecurityGroupManagerCheck -confirm:$false
 }
 }

#convert to shared mailbox and add user to shared mailbox
Set-Mailbox $email -Type shared
Add-MailboxPermission -Identity $email -AccessRights FullAccess -InheritanceType All -AutoMapping:$true -User (Read-Host -Prompt 'Input the email of person needing access to shared inbox')

#remove and office 365 license attached
Connect-MsolService -Credential $UserCredential
Set-MsolUserLicense -UserPrincipalName $email -RemoveLicenses "horizonindustries:ENTERPRISEPACK", "horizonindustries:STANDARDWOFFPACK", "horizonindustries:ATP_ENTERPRISE"
Write-Host "License Removed" -ForegroundColor Green
Read-Host -Prompt "DONE: Press Enter to exit"