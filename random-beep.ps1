While (!$i){
Start-Sleep -Seconds (1..60 | get-random -Count 1)
190..8500 | Get-Random -Count 1 | ForEach {[console]::Beep($_, 200)}
}