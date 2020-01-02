#function to send email through gmail api using the psgsuite module

function send-mail {
#sets parameter and prompts for input for needed information
[CmdletBinding()]
Param($attach, $to, $Subject, $body)


#email signature in html
$sig = @"
<html><head><meta http-equiv="Content-Type" content="text/html; charset=us-ascii"><meta name="Generator" content="Microsoft Word 15 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Georgia;
	panose-1:2 4 5 2 5 4 5 2 3 3;}
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
--></style></head><body lang="EN-US" link="#0563C1" vlink="#954F72"><div class="WordSection1"><p class="MsoNormal">&#160;</p><p class="MsoNormal">&#160;</p><table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="0" style="width:283.5pt;border-collapse:collapse"><tr style="height:85.0pt"><td width="193" valign="top" style="width:116.25pt;border:none;border-right:solid red 1.0pt;padding:5.0pt 5.0pt 5.0pt 5.0pt;height:85.0pt"><p class="MsoNormal"><a href="https://mchest.com/" target="_blank"><span style="font-family:&quot;Georgia&quot;,serif;color:#1c4587;text-decoration:none"><img border="0" width="150" height="96" id="Picture_x0020_1" src="https://i.ibb.co/gRPDQCh/logo.png"></span></a><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p></td><td width="185" valign="top" style="width:116.25pt;padding:5.0pt 5.0pt 5.0pt 5.0pt;height:85.0pt"><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p><p class="MsoNormal"><b><span style="font-size:10.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">Aaron Penick</span></b><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><b><span style="font-size:9.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">IT Support Specialist</span></b><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p></td></tr><tr style="height:19.0pt"><td width="193" valign="top" style="width:116.25pt;border:none;border-right:solid red 1.0pt;padding:5.0pt 5.0pt 5.0pt 5.0pt;height:19.0pt"><p class="MsoNormal"><span style="font-size:8.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">3160 Park Center Dr.</span><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><span style="font-size:8.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">Tyler, TX 75701</span><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><span style="font-size:8.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">Pharmacy Main: 855-MCHEST-1</span><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif">&#160;</span></p></td><td width="185" valign="top" style="width:116.25pt;padding:5.0pt 5.0pt 5.0pt 5.0pt;height:19.0pt"><p class="MsoNormal"><span style="font-size:8.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">Direct: 903-630-6027</span><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p><p class="MsoNormal"><span style="font-size:8.0pt;font-family:&quot;Georgia&quot;,serif;color:#1c4587">Email:&#160;<a href="mailto:apenick@gmail.com" target="_blank"><span style="color:blue">apenick@gmail.com</span></a></span><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif"></span></p></td></tr></table><p class="MsoNormal">&#160;</p><p class="MsoNormal">&#160;</p><p class="MsoNormal">&#160;</p></div></body></html>
"@
#combines body content with html signature
$content = "$body. $sig"




#if statement that will send mail with attachment if parameter is detected.

if($attach) {

  Send-GmailMessage -From apenick@mchest.com -To $to -Subject $subject -Body $content -BodyAsHtml -Attachments $attach

  }  Else {

  Send-GmailMessage -From apenick@mchest.com -To $to -Subject $subject -Body $content -BodyAsHtml   

} 
}