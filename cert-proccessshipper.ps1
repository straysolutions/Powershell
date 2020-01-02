﻿

$comps = Invoke-Command -ComputerName DC.DOMAIN.LOCAL -ScriptBlock {Get-AdComputer -filter *} | Sort-Object Name | SELECT Name
$target = $comps | Out-GridView -PassThru -Title "Select workstation name."
if ($target){if(Test-Connection $($target.Name) -Count 1 -ea SilentlyContinue){
Invoke-Command $target.Name -ScriptBlock {
cls

Write "Installing cert..."
#installs cert 
$var = @'
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlDMURDQ0FieWdBd0lCQWdJUVI0N1pGVGo4ZDdsTFFQa0tHK2RKb3pBTkJna3Foa2lHOXcwQkFRVUZBREFtDQpNU1F3SWdZRFZRUURFeHR3Y205alpYTnpjMmhwY0hCbGNpNWtiMjFoYVc0dWJHOWpZV3d3SGhjTk1Ua3dPREEyDQpNRFV3TURBd1doY05Namt3T0RFek1EVXdNREF3V2pBbU1TUXdJZ1lEVlFRREV4dHdjbTlqWlhOemMyaHBjSEJsDQpjaTVrYjIxaGFXNHViRzlqWVd3d2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURUDQpRVDVubXFZVWdxdHpyOHovdDBjUGd0alA0ajVLZU8xc3NDRXRaVU5jdXZab1lxbStLSHlkUy80N3lRcjBqSDU2DQpjTE8wY0dLZ3YyS2ZwczNEZkZxSHcwb2JrSnZ6dXVGZTFMdGNRWmxQRGp0VVJsUnJyazBJTzgzeWYwRlU5SkpEDQphM2NwYmNNN25Xd0RlMUxTWWFkSlhFOEQ1L2ZIOVdlbk5Hcno4UkhiQ3JXZk5xNm1OYVpjMzE3OGNXcU1vSXdyDQpVNHFBNXAwYnB5UWVDQ1pXSGFsOVN5ekFOUURNWGo1cGpKeURad2R5OG1yTlY0S2FvT2t0Z1hOQWltWlkxWWl0DQpad2ZDUHI0ZUptTE1aQ1IvUW5jZlp4dTM0dU1pRmNaWUFGekdMZkFlM3Aya0xOM0VyZ3ROUlRuM0tjMGQzL0JvDQo0Sk5wNkJPOVRtWkRHd1c2TUZYSkFnTUJBQUV3RFFZSktvWklodmNOQVFFRkJRQURnZ0VCQUo4NjlHQk8waGxsDQpSK3dobW13MWhZaUNBcjFPaTR0cGlkakZjY0RtWWMyQkUwdXFUc0plNFQ4MnFGY215NjV2TUxMUUFOWEtwUmlCDQpDdlZDZWhoVG1uK3duKzlib3h1RHVuZzM2dmYydTFsaVFQMUpLeGk1WDl4WDh5WGhzSDZjcDVsUThmV0MzT3RyDQorUXZGd1F1Z0tFU2huaGpqSU1zc1hDRWdVUityV21YeUxzUkxPalVTV0YzSzFTOHQ4SmNZWXllT2xSaTRBTWppDQpnbU50Wkd6VTE5aG1qc0hOSlc4aExXVEtzeFBhby9ZZWdjZXp4VWs5SzUzcXdCcEE4S3RoUExoSDlMMlFSRjFuDQpEUmdhTnNXeUVJa2grWUZZeU54R29CSWEvcXMwMy9CRlArZ3ZTeWlkN2dvcVlzRFArUmlYK1pma0dlWnEwV1crDQp0dnZYczdGdmNnWT0NCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0NCg==

'@

$Content = [System.Convert]::FromBase64String($var)
Set-Content -Path C:\Temp\processshipper.crt -Value $Content -Encoding Byte
Get-Command -Module PKIClient;
certutil -addstore "Root" C:\Temp\processshipper.crt
}

     }

ELSE{Write-Host "Target:$($target.Name) is not online at this time."}}