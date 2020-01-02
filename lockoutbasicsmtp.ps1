$Report= "c:\html.html" 

$HTML=@" 
<title>Account locked out Report</title> 
<!--mce:0--> 
"@ 

$Account_Name = @{n='Account';e={$_.ReplacementStrings[-1]}} 
$Account_domain = @{n='Domain';e={$_.ReplacementStrings[-2]}} 
$Caller_Computer_Name = @{n='Computer';e={$_.ReplacementStrings[-1]}} 


$event= Get-EventLog -LogName Security -InstanceId 4740 -Newest 1 | 
   Select TimeGenerated,ReplacementStrings,"Account","Domain","Computer" | 
   % { 
     New-Object PSObject -Property @{ 
      "Account" = $_.ReplacementStrings[-7] 
      "Domain" = $_.ReplacementStrings[5] 
      "Computer" = $_.ReplacementStrings[1] 
      Date = $_.TimeGenerated 
    } 
   } 

  $event | ConvertTo-Html -Property "Account","Domain","Computer",Date -head $HTML -body  "<H2>A user is locked in Active Directory</H2>"| 
     Out-File $Report -Append 

$users = Get-ADUser $event.Account -Properties EmailAddress | Select-Object -Property EmailAddress
$email = $users | Select-Object -ExpandProperty EmailAddress
$MailBody= Get-Content $Report 
$MailSubject= "User Account locked out" 
$SmtpClient = New-Object system.net.mail.smtpClient 
$SmtpClient.host = "xxxxxxxx.xxxxxxx.xx" 
$MailMessage = New-Object system.net.mail.mailmessage 
$MailMessage.from = "helpdesk@xxxxxxxxxxx.com" 
$MailMEssage.To.add("support@xxxxxxxxxxx.com")
$MailMessage.Subject = $MailSubject 
$MailMessage.IsBodyHtml = 1 
$MailMessage.Body = $MailBody 
$SmtpClient.Send($MailMessage) 

del c:\html.html