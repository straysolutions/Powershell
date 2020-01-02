function sendtele-jobsdone {
$mytoken = "824375208:AAHr2EzQOrV6dR5g1tZPH5piPPiyktOZukk"
$chatid = 728973503
$Message = "Jobs Done!"
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($MyToken)/sendMessage?chat_id=$($chatID)&text=$($Message)"
}