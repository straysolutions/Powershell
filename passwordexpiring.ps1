#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
-Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
@{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}
 
foreach ($user in $users) {
$exp = $user.PasswordExpiry
$days = @()
foreach ($d in 7,3,1){$days += (get-date).adddays($d).ToLongDateString()}
    if($exp -in $days){
        $count = (New-TimeSpan -Start (Get-Date) -End $exp).Days
        $body = "This is an automated message. This is to inform you that the password for $($user.name)"
        $body += " will expire in $count days on $exp. Please contact the helpdesk if "
        $body += "you need assistance changing your password. PLEASE DO NOT REPLY TO THIS EMAIL."
        Send-MailMessage -To $user.EmailAddress`
                         -From "Password Expiration Warning<email>"`
                         -SmtpServer "XXXXXXX"`
                         -Subject "PASSWORD EXPIRATION WARNING - Your account password will expire soon."`
                         -Body $body
     }
}