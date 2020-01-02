function get-mailboxfolderstats {

connect-o365

$emails = Get-MSOLUser | Sort-Object UserPrincipalName | select UserPrincipalName
$email = $emails | Out-GridView -PassThru -Title "Select workstation name."

Get-MailboxFolderStatistics apenick | select Name, FolderPath, ItemsInFolder, ItemsInFolderAndSubfolders, FolderAndSubfolderSize | out-gridview
}