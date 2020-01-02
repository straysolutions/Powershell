#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
-Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
@{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}

#loops through each user and it expiration matches days listed it will send email 
foreach ($user in $users) {
$exp = $user.PasswordExpiry
$days = @()
#d in X sets the days till expiration. Set here for 7 3 and 1
foreach ($d in 7,5,3,1){$days += (get-date).adddays($d).ToLongDateString()}
    if($exp -in $days){
        $count = (New-TimeSpan -Start (Get-Date) -End $exp).Days
        $body = "This is an automated message. This is to inform you that the password for $($user.name)"
        $body += " will expire in $count days on $exp. Please contact the helpdesk if "
        $body += "you need assistance changing your password. PLEASE DO NOT REPLY TO THIS EMAIL."
$From = "no-reply@mchest.com"
$To = $user.EmailAddress
$Subject = "PASSWORD EXPIRATION WARNING - Your account password will expire soon."
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$username = "no-reply@mchest.com"
$pwdTxt = Get-Content "C:\temp\Secure.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
#sends messsage with declared variables above
Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
-Credential $credObject 
     }
}