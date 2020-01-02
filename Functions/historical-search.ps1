#this function prompts for email details and does a historical detailed message trace and notifies you in email when it is done. This is needed
#for traces over 7 days old
#WARNING THIS FUNCTIONS USES THE CUSTOM FUNCTION CONNECT-O365

function historical-search {

#uses custom function to connect to office 365
connect-o365

#prompts for needed inputs for report
$report = Read-Host -Prompt 'Name of report?'
$email = Read-Host -Prompt 'Sender Email Address?'
$nemail = Read-Host -Prompt 'Email Address to notify when done?'
$startdate = Read-Host -Prompt 'Start Date?'
$enddate = Read-Host -Prompt 'End Date?'

#fires off the report and you will get a email when it is done. Can take up to 2 hours.
Start-HistoricalSearch -ReportTitle "$report name" -StartDate $startdate -EndDate $enddate -ReportType MessageTraceDetail -SenderAddress $email -NotifyAddress $nemail
}
