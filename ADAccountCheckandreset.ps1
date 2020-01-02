#This script will check AD to see if user is locked out and then prompt for a password change/set user to change password 
#at next login


$lock = Get-ADUser ($User = Read-Host -Prompt 'Input the user name') -Properties * | Select-Object LockedOut
if ($lock.lockedout -contains "True")
{
  Write-host "Would you like to unlock account?" -ForegroundColor Yellow
  Unlock-ADAccount $User -confirm  
}
else
{
  Write-Host "Not locked! Press Enter for password reset option" -ForegroundColor Green
  Read-Host -Prompt "."  
}
Write-host "Would you like to reset password? (Default is No)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes, resetting password!!!!" -ForegroundColor Yellow; 
       $password = Read-Host -Prompt "Temp pass?"
       Set-ADAccountPassword $User -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force -Verbose) -PassThru
    Set-ADUser -Identity $User -ChangePasswordAtLogon $true} 
       N {Write-Host "No, Skipping"; exit} 
       Default {Write-Host "No, Skipping" -ForegroundColor Green; exit} 
     } 
Read-Host -Prompt "Press Enter to exit"
