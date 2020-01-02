$computer = Read-Host -Prompt 'Computer Name?'
Invoke-Command -ComputerName $computer -ScriptBlock {slmgr -ipk  YBCFQ-P9VK9-RRRTJ-WC7XH-497JG}

Invoke-Command -ComputerName $computer -ScriptBlock {slmgr -ato}