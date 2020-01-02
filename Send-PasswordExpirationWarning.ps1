#Create warning dates for future password expiration
$SevenDayWarnDate = (get-date).adddays(7).ToLongDateString()
$ThreeDayWarnDate = (get-date).adddays(3).ToLongDateString()
$OneDayWarnDate = (get-date).adddays(1).ToLongDateString()
 
#Email Variables
$MailSender = " Password Expiration Warning <IT@horizonind.com>"
$Subject = 'PASSWORD EXPIRATION WARNING - Your account password will expire soon'
$EmailStub1 = 'This is an automated message. I am here to inform you that the password for'
$EmailStub2 = 'will expire in'
$EmailStub3 = 'days on'
$EmailStub4 = '. Please contact the helpdesk if you need assistance changing your password. PLEASE DO NOT REPLY TO THIS EMAIL.'
$SMTPServer = 'smtp.domain.local'
 
#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}
 
#check password expiration date and send email on match
foreach ($user in $users) {
     if ($user.PasswordExpiry -eq $SevenDayWarnDate) {
         $days = 7
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $SevenDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $ThreeDayWarnDate) {
         $days = 3
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $ThreeDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject `
         -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $oneDayWarnDate) {
         $days = 1
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
    else {}
 }