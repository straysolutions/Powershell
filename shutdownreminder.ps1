$rnd = Get-Random -Minimum 1 -Maximum 3600
$smtpServer = "SMTP"
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)

Start-Sleep -Seconds $rnd
$msg.From =  'Aaron Penick<apenick@horizonind.com>'
$msg.To.Add("AllEmails@horizonind.com")
$msg.subject = "Friday Shutdown Reminder"


	
$msg.IsBodyHtml = $True

$body = @"
<html>
<body>
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii"><meta name=Generator content="Microsoft Word 15 (filtered medium)"><!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]--></head><body lang=EN-US link="#0563C1" vlink="#954F72"><div class=WordSection1><p class=MsoNormal>Happy Friday to all,<o:p></o:p></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal>Just a friendly reminder from IT, when leaving today please turn off your computer instead of locking it.<o:p></o:p></p><p class=MsoNormal>This provides us the maintenance window over the weekend to perform task that would otherwise disrupt workday hours.<o:p></o:p></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal>If you use your computer to log into paycom, please account for the time it may take to start back up when arriving Monday.<o:p></o:p></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal>As always any questions, comments, or concerns, please let us know and have a great weekend!<o:p></o:p></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal>--<o:p></o:p></p><table class=MsoNormalTable border=0 cellspacing=3 cellpadding=0 width=738 style='width:553.5pt'><tr><td width=487 nowrap valign=bottom style='width:365.25pt;padding:1.5pt 1.5pt 1.5pt 1.5pt'><p class=MsoNormal><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:black'>Aaron Penick</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;color:black'><o:p></o:p></span></p><p class=MsoNormal><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:black'>JR. Systems/Network Admin</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;color:black'><o:p></o:p></span></p><p class=MsoNormal><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:black'>500 N Bois D' Arc | Tyler, TX 75702</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;color:black'><o:p></o:p></span></p><p class=MsoNormal><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:black'>Tel: 903.590.4308 </span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;color:black'><o:p></o:p></span></p><p class=MsoNormal><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:black'>&nbsp;<a href="mailto:apenick@horizonind.com"><span style='color:blue'>apenick@horizonind.com</span></a> | </span><span style='font-size:14.0pt;font-family:"Times New Roman",serif;color:#1F497D'><a href="http://www.horizonind.com/"><span style='color:blue'>www.horizonind.com</span></a>&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;color:#1F497D'><o:p></o:p></span></p></td><td width=233 valign=bottom style='width:174.75pt;padding:1.5pt 1.5pt 1.5pt 1.5pt'></td></tr></table><p class=MsoNormal><o:p>&nbsp;</o:p></p><p 
<img src="cid:image1.jpg">
</body>
</html>
"@

$msg.Body = $body

$attachment = New-Object System.Net.Mail.Attachment –ArgumentList  "\\Fileserv.domain.local\res$\Outlook_Signature_Templates\Main\Main_files\image001.jpg"
$attachment.ContentDisposition.Inline = $True
$attachment.ContentDisposition.DispositionType = "Inline"
$attachment.ContentType.MediaType = "image/jpg"
$attachment.ContentId = 'image1.jpg'
$msg.Attachments.Add($attachment)

$smtp.Send($msg)
$attachment.Dispose();
$msg.Dispose();