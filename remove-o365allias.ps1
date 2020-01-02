$mailboxes = get-mailbox -resultsize unlimited
Foreach ($mbx in $mailboxes) {
$name = $mbx.name
$suffix = '@etlb.org'
$address = $name + $suffix
Set-mailbox $name -emailaddresses @{remove=$address}}