function get-currentcomputers {
Get-ADComputer -Filter * -SearchBase "OU=Local Computers, DC=domain, DC=local" | select name | out-file C:\Scripts\currentcomputers.txt
}