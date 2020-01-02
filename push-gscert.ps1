#pops up a window with all computers in AD
$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT DNSHostName
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."

foreach($item in $target.DNSHostName)
{
#installs cert
if ($target){if(Test-Connection $($target.DNSHostName) -Count 1 -ea SilentlyContinue){Invoke-Command $($target.DNSHostName) -ScriptBlock {
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

}}ELSE{Write-Host "Target:$($target.DNSHostName) is not online at this time."}} 
}
