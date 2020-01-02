

$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock {
cls
#checks both parts of registry for quoted software name and grabs uninstall string
$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "SSClient" } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "SSClient" } | select UninstallString
if ($uninstall64) {
#cleans up uninstall string and preps it to be fed as arg
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /q"}
if ($uninstall32) {
#cleans up uninstall string and preps it to be fed as arg
$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall32 = $uninstall32.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall32 /q"}
Start-Sleep -Seconds 30
Write "Cleaning up..."
$users = Get-ChildItem -Path "C:\Users"

# Loop through users and delete the file
$users | ForEach-Object {
    Remove-Item -Path "C:\Users\$($_.Name)\AppData\Local\Square_9_Softworks" -Force -Recurse
}
Remove-Item -Path "C:\Program Files (x86)\Common Files\Square9" -Force -Recurse
Start-Sleep -Seconds 5
Write "Installing cert..."
#installs cert 
$var = @'
MIIDGTCCAgGgAwIBAgIQ02FlFgSGd4ZAVDMU/ut+MjANBgkqhkiG9w0BAQsFADAe
MRwwGgYDVQQDExNHU1NFUlYuRE9NQUlOLkxPQ0FMMB4XDTE5MDEwMTA1MDAwMFoX
DTMwMDEwMTA1MDAwMFowHjEcMBoGA1UEAxMTR1NTRVJWLkRPTUFJTi5MT0NBTDCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALX54RqVozaW9X+JLYO44C3x
O3pS7U9jVkqA/YWEKKwbdVPJiOkKPocuBL5gU5B9z7+x0/DnCE0CkilemDSEPAZC
ZLMvfpd4vCtaEzIY9ROjANFSgpBDF+q7dOQVdghTRTebCzHiRG1+R4232idpn2EQ
hF2BlMgFMFaQ7QjoHNFgoJI+UdKtoWWojIzgF/KWY0TJ7Cfjhde//67o5XrAS5cu
5sr8X4JaiSKauXNthh8QSUNCfRq5dkYO0zx75mzLDyTvi/Ns0FP5sXQCdEL3OPAx
AlzYT1RtCmQqm6JVRud39vntiRlDRDgbdJ0teThLhfAa6HHByKwKX8sL3wcevmEC
AwEAAaNTMFEwTwYDVR0BBEgwRoAQ1NQA6Vy3chBW6Q6ZNv/bCaEgMB4xHDAaBgNV
BAMTE0dTU0VSVi5ET01BSU4uTE9DQUyCENNhZRYEhneGQFQzFP7rfjIwDQYJKoZI
hvcNAQELBQADggEBAJueS+74S3bdjMoHhqrFd1Hd8CliqHtsgd9DX5jnUmo/4vg+
nRmXKv1ACpqjrnwzJJazweacNe1gix4RifKj87c0png7saCtCky1r9rrz4kHbEWb
aUdY4VTTuohQRi+pTRslL4sBO68eXGz2yXZeh2bsWNXwHhOlVYN2p9ZP6okqzx/W
ZjJKk6T69e3wZlAuDld0lpza232bU/2pL4GNuIy1GdQ8OVW0aQo7LPuaX3ySXRoM
Ns3TpNmUtawp8Qze5hbKKtI3d6jfeqZVAkfXqLZk3zfcYZOdgW/Ay+7l1J/EG1BX
KfPgOf/IPX4aL8tdOvEocOVDvuzLPKzDNq4jE9Y=
'@

$Content = [System.Convert]::FromBase64String($var)
Set-Content -Path C:\Temp\GSSERVDOMAINLOCAL.crt -Value $Content -Encoding Byte
Get-Command -Module PKIClient;
certutil -addstore "Root" C:\Temp\GSSERVDOMAINLOCAL.crt
Write "Rebooting in 30 seconds..."
#reboots computer
Shutdown /r /t 30
}

     }

ELSE{Write-Host "Target:$($target.Name) is not online at this time."}}


