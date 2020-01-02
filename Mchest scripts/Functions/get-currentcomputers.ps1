function get-currentcomputers {
Get-ADComputer -Filter * -SearchBase "OU=Location, DC=mchest, DC=net" | select name | out-file C:\Scripts\currentcomputers.txt
}