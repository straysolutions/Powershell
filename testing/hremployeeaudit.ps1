
#remove spaces from headers so they can be called properly
$a = Get-Content "C:\temp\Monthly Employee Update.csv"


$a[0] = $a[0] -replace " ", ""

$a | Set-Content "C:\temp\Monthly Employee Update.csv"

#combines manager names
Import-Csv "C:\temp\Monthly Employee Update.csv" | Select-Object @{Name = "Manager"; Expression = {$_."ReportsToFirstName" + " " + $_."ReportsToLastName"}}, * | Export-Csv -NoTypeInfo -Path "C:\temp\withmanagername.csv"

#replaces some proper manager names with how they are listed in AD
[io.file]::readalltext(“C:\temp\withmanagername.csv”).replace(“Douglas Sloan”,”Doug Sloan”) | Out-File “C:\temp\withmanagername.csv” -Encoding ascii –Force
[io.file]::readalltext(“C:\temp\withmanagername.csv”).replace(“Jason Haire”,”Jason P. Haire”) | Out-File “C:\temp\withmanagername.csv” -Encoding ascii –Force
[io.file]::readalltext(“C:\temp\withmanagername.csv”).replace(“William Mayeux”,”William H. Mayeux”) | Out-File “C:\temp\withmanagername.csv” -Encoding ascii –Force
[io.file]::readalltext(“C:\temp\withmanagername.csv”).replace(“Joshua Kennedy”,”Josh Kennedy”) | Out-File “C:\temp\withmanagername.csv” -Encoding ascii –Force
[io.file]::readalltext(“C:\temp\withmanagername.csv”).replace(“Daniel Rich”,”Danny Rich”) | Out-File “C:\temp\withmanagername.csv” -Encoding ascii –Force

#removes spaces from the end of the job title field
Import-Csv "C:\temp\withmanagername.csv" | ForEach-Object {
        $_.JobTitleDescription = $_.JobTitleDescription.trim()
        $_
} | Export-Csv "C:\temp\clean.csv" -NoTypeInformation


# Import CSV from HR
$HR = import-csv -path "C:\temp\clean.csv"
# pull all users in the OU that have a title and email
$adUsers = get-aduser -filter {title -like "*" -and mail -like "*"  } -SearchBase "OU=Location,DC=MCHEST,DC=NET" -Properties givenname, surname, title, manager | Select-Object givenname, surname, title,@{name='ManagerName';expression={(Get-ADUser -Identity $_.manager | Select-Object -ExpandProperty name)}} | sort-object givenname
# array of users that match our known good input
$matchUsers = @()
# array of users NOT matching our known good input
$notMatchUsers = @()

foreach ($user in $adUsers){

    #makes sure title and manager match. Left off name as we do not force AD to have proper name
    if ($HR.JobTitleDescription -eq $user.title -and $HR.manager -eq $user.ManagerName) {
        $matchUsers += $user
    } 
    else {

    $notMatchUsers += $user
    }


}

#creates two files to show matched and not matched.
$matchUsers | export-csv  -NoTypeInformation -Path "c:\temp\match.csv"
$notmatchusers | export-csv   -NoTypeInformation -path "c:\temp\notmatch.csv"

#little bit of clean up. Leaves original CSV so you can compare to notmatch csv
Remove-Item -Path "C:\temp\withmanagername.csv" -Force
Remove-Item -Path "C:\temp\clean.csv" -Force