$User = Read-Host -Prompt 'Computer Account?'
Get-AdmPwdPassword $User
Read-Host -Prompt "Donezo"