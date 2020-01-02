#This script allows you to do a mesage trace, get mailbox size, or get mailbox folder stats depending on what you choose in first menu.

#Declaring all the functions

function connect-o365 {


#*******WARNING******This uses a password file converted to secure string that should already be in place. To create one yourself use the below commented command. Also change the email below.
#If for some reason it starts prompting you for password again after using connect-o365 for awhile then recreate your saved password.
#Read-Host “Type your Office 365 Exchange Online password: ” –AsSecureString | ConvertFrom-SecureString | Set-Content C:\Scripts\o365.txt
$SecureData = cat C:\Scripts\o365.txt | convertto-securestring

#change the email in the below line to your email
$LiveCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "apenick@horizonind.com",$SecureData

Import-Module MSOnline

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session


Start-Sleep -Seconds 5
Connect-MsolService -Credential $LiveCred


}

function get-mailboxsize {
#custom function to connect to o365
connect-o365
#promtp for email. Here you can enter more than one just make sure you do @email,@email with no spaces
$emails = Get-Mailbox -ResultSize Unlimited | Sort-Object PrimarySmtpAddress |Select-Object PrimarySmtpAddress, @{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq “smtp”} | ForEach-Object {$_.SmtpAddress}}}
$email = $emails | Out-GridView -PassThru -Title "Select Email."
#cleans up read-host input for an array and loops through getting mailbo sizes
$results = foreach($item in $email.PrimarySmtpAddress)
{get-mailbox -Identity $item | get-mailboxstatistics | Select-Object displayname, totalitemsize }
#array results pipped to out-gridview
$results | Sort-Object DisplayName | Out-GridView
Get-PSSession | Remove-PSSession
}

function message-trace {
#calls conneco365 function to connect to office 365 through powershell
connect-o365

#prompts for input on email to be trace
$emails = Get-Mailbox -ResultSize Unlimited | Sort-Object PrimarySmtpAddress |Select-Object PrimarySmtpAddress, @{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq “smtp”} | ForEach-Object {$_.SmtpAddress}}}
$email = $emails | Out-GridView -PassThru -Title "Select Email."
Function get-Calendar {  

  $form = new-object Windows.Forms.Form  
  $form.text = "Calendar"  
  $form.Size = new-object Drawing.Size @(656,639)  

  # Make "Hidden" SelectButton to handle Enter Key 

  $btnSelect = new-object System.Windows.Forms.Button 
  $btnSelect.Size = "1,1" 
  $btnSelect.add_Click({  
    $form.close()  
  })  
  $form.Controls.Add($btnSelect )  
  $form.AcceptButton =  $btnSelect 

  # Add Calendar  

  $cal = new-object System.Windows.Forms.MonthCalendar  
  $cal.ShowWeekNumbers = $true  
  $cal.MaxSelectionCount = 356 
  $cal.Dock = 'Fill'  
  $form.Controls.Add($cal)  

  # Show Form 

  $Form.Add_Shown({$form.Activate()})   
  [void]$form.showdialog()  

  # Return Start and end date  

  return $cal.SelectionRange 
}  

$date = get-Calendar

#runs a message trace and outputs to gridview
Get-MessageTrace -SenderAddress $email.PrimarySmtpAddress -StartDate $date.Start -EndDate $date.end | Get-MessageTraceDetail | Select-Object MessageID, Date, Event, Action, Detail, Data | Out-GridView
Get-PSSession | Remove-PSSession
}

function get-mailboxfolderstats {

connect-o365

$emails = Get-Mailbox -ResultSize Unlimited | Sort-Object PrimarySmtpAddress |Select-Object PrimarySmtpAddress, @{Name=“EmailAddresses”;Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq “smtp”} | ForEach-Object {$_.SmtpAddress}}}
$email = $emails | Out-GridView -PassThru -Title "Select Email."

Get-MailboxFolderStatistics $email.PrimarySmtpAddress | select Name, FolderPath, ItemsInFolder, ItemsInFolderAndSubfolders, FolderAndSubfolderSize | Out-GridView
Get-PSSession | Remove-PSSession
}

$Menu = [ordered]@{

  1 = 'Get Mailbox Size'

  2 = 'Get Mailbox Folders and Size of Folders'

  3 = 'Do A Message Trace'

  }

  

  $Result = $Menu | Out-GridView -PassThru  -Title 'Make a  selection'

  Switch ($Result)  {

  {$Result.Name -eq 1} {get-mailboxsize}

  {$Result.Name -eq 2} {get-mailboxfolderstats}

  {$Result.Name -eq 3} {message-trace}   

} 