
#This function is to connect with Office 365 simply by using "connect-o365" within a powershell window. 

function connect-o365 {


#This uses a password file converted to secure string that should already be in place. To create one yourself use the below commented command
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