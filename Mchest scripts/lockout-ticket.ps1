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
     Out-File "C:\temp\html.html" 



$From = "no-reply@mchest.com"
$To = "support@mchest.com"
$Subject = "User Account locked out"
$Body = Get-Content "C:\temp\html.html" -Raw
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$username = "no-reply@mchest.com"
$pwdTxt = Get-Content "C:\temp\Secure.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
#sends messsage with declared variables above
Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -BodyAsHtml -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
-Credential $credObject

del c:\temp\html.html