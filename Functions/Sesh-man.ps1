function Sesh-Man {

#script to combine session killer and remote help. declares them  them as functions and displays a basic menu to select which option to launch. 

function rdsremotehelp {
#Version 2

#list of RDS servers

$Servers = @(
"SERVERS HERE"
)

#Initialize $Sessions which will contain all sessions
[System.Collections.ArrayList]$Sessions = New-Object System.Collections.ArrayList($null)

#Go through each server
Foreach ($Server in $Servers)  {
	#Get the current sessions on $Server and also format the output
	$DirtyOuput = (quser /server:$Server) -replace '[ \t]{2,}', ',' | ConvertFrom-Csv
	
	#Go through each session in $DirtyOuput
	Foreach ($session in $DirtyOuput) {
	#Initialize a temporary hash where we will store the data
	$tmpHash = @{}
	
	#Check if SESSIONNAME isn't like "console" and isn't like "rdp-tcp*"
	If (($session.sessionname -notlike "console") -AND ($session.sessionname -notlike "rdp-tcp*")) {
		#If the script is in here, the values are shifted and we need to match them correctly
		$tmpHash = @{
		Username = $session.USERNAME
		SessionName = "" #Session name is empty in this case
		ID = $session.SESSIONNAME
		State = $session.ID
		IdleTime = $session.STATE
		LogonTime = $session."IDLE TIME"
		ServerName = $Server
		}
		}Else  {
		#If the script is in here, it means that the values are correct
		$tmpHash = @{
		Username = $session.USERNAME
		SessionName = $session.SESSIONNAME
		ID = $session.ID
		State = $session.STATE
		IdleTime = $session."IDLE TIME"
		LogonTime = $session."LOGON TIME"
		ServerName = $Server
		}
		}
		#Add the hash to $Sessions
		$Sessions.Add((New-Object PSObject -Property $tmpHash)) | Out-Null
	}
}
  
#Display the sessions, sort by name, and just show Username, ID and Server
#$sessions | Sort Username | select Username, ID, ServerName 

#display in outgrid view for selection.
$target = $sessions | Sort Username | Out-GridView -PassThru -Title  "Select session."
$id = $target | select -ExpandProperty ID
$srv = $target | select -ExpandProperty ServerName

#pass to mstsc and launch support window
Mstsc.exe /shadow:$id /v:$srv /control
}

function rdssessionkiller {
#script to list all RDS sessions and close the session

#list of RDS servers

$Servers = @(
"SERVERS HERE"
)

#Initialize $Sessions which will contain all sessions
[System.Collections.ArrayList]$Sessions = New-Object System.Collections.ArrayList($null)

#Go through each server
Foreach ($Server in $Servers)  {
	#Get the current sessions on $Server and also format the output
	$DirtyOuput = (quser /server:$Server) -replace '[ \t]{2,}', ',' | ConvertFrom-Csv
	
	#Go through each session in $DirtyOuput
	Foreach ($session in $DirtyOuput) {
	#Initialize a temporary hash where we will store the data
	$tmpHash = @{}
	
	#Check if SESSIONNAME isn't like "console" and isn't like "rdp-tcp*"
	If (($session.sessionname -notlike "console") -AND ($session.sessionname -notlike "rdp-tcp*")) {
		#If the script is in here, the values are shifted and we need to match them correctly
		$tmpHash = @{
		Username = $session.USERNAME
		SessionName = "" #Session name is empty in this case
		ID = $session.SESSIONNAME
		State = $session.ID
		IdleTime = $session.STATE
		LogonTime = $session."IDLE TIME"
		ServerName = $Server
		}
		}Else  {
		#If the script is in here, it means that the values are correct
		$tmpHash = @{
		Username = $session.USERNAME
		SessionName = $session.SESSIONNAME
		ID = $session.ID
		State = $session.STATE
		IdleTime = $session."IDLE TIME"
		LogonTime = $session."LOGON TIME"
		ServerName = $Server
		}
		}
		#Add the hash to $Sessions
		$Sessions.Add((New-Object PSObject -Property $tmpHash)) | Out-Null
	}
}
  
#Display the sessions, sort by name, and just show Username, ID and Server
#$sessions | Sort Username | select Username, ID, ServerName 

#display in outgrid view for selection.
$target = $sessions | Sort Username | Out-GridView -PassThru -Title  "Select session."
$id = $target | select -ExpandProperty ID
$srv = $target | select -ExpandProperty ServerName

#pass to mstsc and launch support window
rwinsta /SERVER:$srv $id
}

function Show-Menu
{
     param (
           [string]$Title = 'Sesh-Man'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to shadow a session."
     Write-Host "2: Press '2' to kill an existing session."
     Write-Host "Q: Press 'Q' to quit."
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'You chose to remote into a session. Please wait while the session list loads...'
                rdsremotehelp
           } '2' {
                cls
                'You chose to murder a session :(   Please wait while the session list loads...'
                rdssessionkiller
           
           } 'q' {
                return
           }
     }
     pause
}
until ($input)

cls
}
