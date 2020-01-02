#prompt for info and create account based on location

$firstname = Read-Host -Prompt 'First Name?'
$lastname = Read-Host -Prompt 'Last Name?'
$adname = Read-Host -Prompt 'Username?'
$title = Read-Host -Prompt 'Title?'
$password = Read-Host "Enter password" -AsSecureString

function Show-Menu
{
     param (
           [string]$Title = 'Department???'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for Brazos."
     Write-Host "2: Press '2' for DEV."
     Write-Host "3: Press '3' for DFW."
     Write-Host "4: Press '4' for Email Only."
     Write-Host "5: Press '5' for Houston."
     Write-Host "6: Press '6' for MCIP."
     Write-Host "7: Press '7' for Med Call."
     Write-Host "8: Press '8' to Outside Sales."
     Write-Host "9: Press '9' to Plano."
     Write-Host "10: Press '10' to SS."
     Write-Host "11: Press '11' to Tyler."
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
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Brazos,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
                
           } '2' {
                cls
                'You chose option #2'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=DEV,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '3' {
                cls
                'You chose option #3'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=DFW,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '4' {
                cls
                'You chose option #4'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Email Only,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '5' {
                cls
                'You chose option #5'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Houston,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '6' {
                cls
                'You chose option #6'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=MCIP,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon -Title "$title" -EmailAddress "$adname@mchest.com"
           } '7' {
                cls
                'You chose option #7'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=MedCall,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '8' {
                cls
                'You chose option #8'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Outside Sales,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '9' {
                cls
                'You chose option #9'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Plano,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title"  -EmailAddress "$adname@mchest.com"                 
           } '10' {
                cls
                'You chose option #10'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=SS,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -Title "$title" -EmailAddress "$adname@mchest.com"
           } '11' {
                cls
                'You chose option #11'
                New-ADUser -Name "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -SamAccountName "$adname" -DisplayName "$firstname $lastname" -Description "$title" -UserPrincipalName "$adname@mchest.net" -Path "OU=Tyler,OU=Location,DC=mchest,DC=net" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true -ScriptPath "login.bat" -Title "$title" -EmailAddress "$adname@mchest.com"                  
                 
                 
           } 'q' {
                return
           }
     }
     pause
}
until ($input)

#AD User mirror groupmembership from other user

$CopyFromUser = Get-ADUser (Read-Host -Prompt 'Input the user name to copy group membership from') -prop MemberOf
$CopyToUser = $adname
$CopyFromUser.MemberOf | Where{$CopyToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $CopyToUser