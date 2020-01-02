function get-userlist {
Get-ADUser -Filter * -SearchBase "dc=mchest,dc=net" | select Name | Export-Csv C:\Scripts\users.csv
}