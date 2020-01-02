#this function will connect to o365 with another custom function, prompt for email address and get that emails maiulbox size
function get-mailboxsize {
#custom function to connect to o365
connect-o365
#promtp for email. Here you can enter more than one just make sure you do @email,@email with no spaces
$email = Read-Host -Prompt 'Email Address? (you can enter more than one separate with comma)'
#cleans up read-host input for an array and loops through getting mailbo sizes
$data = $email.split(",").trim(" ")
$results = foreach($item in $data)
{get-mailbox -Identity $item | get-mailboxstatistics | Select-Object displayname, totalitemsize }
#array results pipped to out-gridview
$results | Out-GridView
}