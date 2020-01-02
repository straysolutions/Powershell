function sendtele-jenn {
$say = Read-Host -Prompt 'Message?'
$mytoken = "824375208:AAHr2EzQOrV6dR5g1tZPH5piPPiyktOZukk"
$chatid = 191368345
$Message = "$say!"
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($MyToken)/sendMessage?chat_id=$($chatID)&text=$($Message)"
}