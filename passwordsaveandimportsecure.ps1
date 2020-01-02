
#converts password to securestring file
$username = "no-reply@mchest.com"
$password = "5kBB6HHjZC7j"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
Set-Content "C:\temp\Secure.txt" $secureStringText

#uses file to insert password as creds for the cred commandlet
$username = "better.admin@acme.com.au"
$pwdTxt = Get-Content "C:\temp\Secure.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd