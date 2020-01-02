Import-Module -Name PSGSuite

Send-GmailMessage -From apenick@mchest.com -To aaronpenick@gmail.com -Subject "This is a test" -Body $body -BodyAsHtml -Attachments 'C:\Scripts\currentcomputers.txt'