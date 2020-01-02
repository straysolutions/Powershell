$CopyFromUser = Get-ADUser (Read-Host -Prompt 'Input the user name to copy') -prop MemberOf
$CopyToUser = Get-ADUser (Read-Host -Prompt 'Input the user name to that needs memebership') -prop MemberOf
$CopyFromUser.MemberOf | Where{$CopyToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Member $CopyToUser