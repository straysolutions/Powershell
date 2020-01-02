$BotToken = "824375208:AAHr2EzQOrV6dR5g1tZPH5piPPiyktOZukk"
$ChatID = 728973503

#Array of Messages, they'll be used depending on the
$Messages = @(
	"Hello, please let me know once you've finished writing the script!"
	"Thank you for finishing the script, %NAMEOFTHEHERO%!"
	"Hello, can you please go and finish the script? This is the %NTIME% time I'm asking you!"
)

#Magic Word to stop the cycle
$MagicWord = "Done"

#Time to wait before sending a new reminder (in seconds - This is an approximate time and it'll depend on how quick the Invoke-WebRequest is)
$SleepTime = 600

#Time to sleep for each loop before checking if a message with the magic word was received
$LoopSleep = 3

#Send initial message
$InitialMessageDate = [Int] (get-date -UFormat %s) #Unix Format (seconds since 1/1/1970), needed as the bot will also work with this format
$InitialRestResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Messages[0])"

#Get the Time Zone: This is needed to make sure the InitialMessageDate isn't ahead or behind Telegram's Date (due to daylight saving etc).
$TimeZone = Get-CimInstance win32_timezone
#TimeZone.Bias will have the amount of MINUTES to be subtracted from InitialMessageDate, which is in seconds, that's why we're multiplying by 60
$TimeZoneBiasInSeconds = ($TimeZone.Bias)*60
#Finally, $InitialMessageDate_NoDaylightSavings will be in the same timezone as Telegram's updates
$InitialMessageDate_NoDaylightSavings = $InitialMessageDate - $TimeZoneBiasInSeconds


#Read the responses in a while cycle until the "MagicWord is matched"
$DoNotExit = 1
$Counter = 1 #This will count the amount of time the Bot is asking!
$SleepStartTime = [Int] (get-date -UFormat %s) #This will be used to check if the $SleepTime has passed yet before sending a new notification out
While ($DoNotExit)  {

  Sleep -Seconds $LoopSleep
  
  #Get the current Bot Updates and store them in an array format to make it easier
  $BotUpdates = Invoke-WebRequest -Uri "https://api.telegram.org/bot$($BotToken)/getUpdates"
  $BotUpdatesResults = [array]($BotUpdates | ConvertFrom-Json).result
  
  
  ForEach ($BotUpdate in $BotUpdatesResults)  {
    If (($BotUpdate.Message.Chat.ID -eq $ChatID) -AND ($BotUpdate.Message.Date -gt $InitialMessageDate_NoDaylightSavings)) {
	  #So, if ChatID matches and also the time of this message we're checking is greater than when the Bot sent the original message,
	  #we can now check if the Message contains the Magic Word!
	  If ($BotUpdate.Message.Text -eq $MagicWord)  {
	    $DoNotExit = 0
		#Get the User who's sent the magic word
	    $HeroOfTheMagicWord = $BotUpdate.message.from.first_name
		
		$ExitMessage = $Messages[1] -Replace ("%NAMEOFTHEHERO%",$HeroOfTheMagicWord)
		$ExitRestResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($ExitMessage)"
		
		#Exit the foreach
		break
	  }
	}
  }
  
  
  
  #If the MagicWord hasn't been received, and the SleepTime has been reached
  $CurrentTime = [Int] (get-date -UFormat %s)
  If ($DoNotExit -AND ($CurrentTime -gt ($SleepStartTime + $SleepTime)))  {
    $Counter++
	$NextMessage = $Messages[2] -Replace ("%NTIME%",$Counter)
    $NextRestResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($NextMessage)"
	$SleepStartTime = [Int] (get-date -UFormat %s) #Reset the SleepStartTime with the current time
  }
}