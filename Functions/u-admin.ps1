function u-admin {

$target = Get-ADUser -Filter * -SearchBase "DC=MCHEST,DC=NET" | select SamAccountName, Name | sort -property SamAccountName | Out-GridView -PassThru -Title  "Select User."
$user = $target | select -ExpandProperty SamAccountName

function Replicate-AllDomainController {
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}

function get-passwordexpiration {

#$user = Read-Host -Prompt 'Username?'

(Get-ADUser -Identity $user -Properties msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' |ForEach-Object -Process{[datetime]::FromFileTime($_)}
}

function get-locked {
#Setup arrays
$LockedUsers = @()
 
#=======================================================================
#Checking locked users
Search-ADAccount -LockedOut | select -first 10 | foreach{
    $City = $Object = $Null
    $City = (Get-ADUser -Identity $_.name -Properties City).City
    $Object = New-Object PSObject -Property ([ordered]@{ 
        Name         = $_.name
        Locked       = $_.lockedout
        Location     = $City
        UPN          = $_.UserPrincipalName        
    })
    $LockedUsers += $Object
}
"Currently locked users:"
$LockedUsers | Format-Table -AutoSize -Wrap
}

function Show-Menu
{
     param (
           [string]$Title = 'USER ADMIN'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to check locked users."
     Write-Host "2: Press '2' to check password expiration."
     Write-Host "3: Press '3' to unlock account."
     Write-Host "4: Press '4' to reset user password."
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
                'You chose to check account lockouts. If no UIDs listed then no lockouts exists.'
                get-locked
           } '2' {
                cls
                'You chose to check password expiration. Please wait while the expiration date loads...'
                get-passwordexpiration
           } '3' {
                cls
                'You chose to unlock the account. Please wait...'
                Unlock-ADAccount -Identity $user
                Replicate-AllDomainController
           } '4' {
                cls
                'You chose to reset the password. Please wait...'
                $password = Read-Host -Prompt 'Password?'
                Set-ADAccountPassword -Identity $user -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)
                Replicate-AllDomainController

           } 'q' {
                return
           }
     }
     pause
}
until ($input)

cls
}