#this function prompts for email details and does a message trace putting the data in out-gridview
#WARNING THIS FUNCTIONS USES THE CUSTOM FUNCTION CONNECT-O365

function message-trace {
#calls conneco365 function to connect to office 365 through powershell
connect-o365

#prompts for input on email to be trace
$email = Read-Host -Prompt 'Sender Email Address?'
$startdate = Read-Host -Prompt 'Start Date?'
$enddate = Read-Host -Prompt 'End Date?'

#runs a message trace and outputs to gridview
Get-MessageTrace -SenderAddress $email -StartDate $startdate -EndDate $enddate | Get-MessageTraceDetail | Select-Object MessageID, Date, Event, Action, Detail, Data | Out-GridView

}