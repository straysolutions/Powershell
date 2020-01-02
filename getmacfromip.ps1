<#
    .Synopsis
    Get the associated manufacturer for a MAC address from http://macvendors.co
    .DESCRIPTION
    This script gets the associated manufacturer for a MAC address by querying the API of http://macvendors.co
    This is an advance function, dot source to use it.
    .PARAMETER Anonymize
    By default, true, changing last two octets to 00:00
    .EXAMPLE
    Get-MACMan '28-F1-0E-01-02-03'
    Get the Manufacturer for device with '28-F1-0E-01-01-01' Mac Address
    .EXAMPLE
    $MacAddress = '28:F1:0E:01:02:03','00-05-9A-01-02-03','E4-A4-71-01-02-03'
    Get-MACMan $MacAddress 
    Get manufacturers of 3 MAC addresses - Dell, Cisco and Intel
    .Notes
    Alan Kaplan
    version 1.1 4-18-19 added support for alternate MAC format of 0000.1111.2222
#>
function Get-MACMan {
    [CmdletBinding()]
    Param
    (
        # MAC is a MAC Adress with - or : format
        [Parameter (
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [string[]]
        $MacAddress,

        # Anonymize MAC
         [Parameter (
            Mandatory = $False,
            Position = 2
        )]
        [ValidateSet($true,$false)]
        [bool] $Anonymize = $true
    )

    Begin {
        $regExp = '^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$'
        $webClient = new-object System.Net.WebClient
        $webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials;

        $aHT = @()
    
            #helper function
            function AddToArrayHash($Key, $val) {
                #Get information and store
                $aHT.add( $Key, $Val ) 
                Write-Host "Added $Key with value $Val"
            }
        
    }
    Process
    {
        Foreach ($m in $MacAddress) {
            $m = $m.toString().ToUpper().trim()
            if 
            ( 
                ( [regex]::matches($m, '\.').count -eq 2 ) -and ( $m.length -eq 14 ) 
            ) 
            {
                $m = $m.replace('.', '')
                #https://powershell.org/forums/topic/add-colon-between-every-2-characters/
                $m = ($M -replace '(..)', '$1:').trim(':')
            }
            
            if 
            (
                ![regex]::IsMatch($m, $regExp)
            ) 
            {
                Write-Warning "$m is not a valid MAC address"
            }
            ELSE 
            {
                $M = $m.Replace('-', ':')
                if ($anonymize) { $m = $m.Remove(12) + '00:00'}
                $retval = $webClient.DownloadString("https://macvendors.co/api/$m")|
                    ConvertFrom-Json  |
                    Select-Object -ExpandProperty result
            }
            $retval
            $aHT += $retval
        }
    }
    End 
    {
    }
}

#region Dot Source Reminder
$ScriptPath = $MyInvocation.MyCommand.Definition.ToString()
## Presume function name is same as script name, or hard code name of function as $fn
$fn = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$dsrRanVarName = "$fn`_Ran"
$DSContinue = Try {Get-Variable $dsrRanVarName -ValueOnly -ErrorAction Stop}Catch {$false}
if ($DSContinue -eq $false) {
    $ScriptTxt = Get-Content $ScriptPath
    $MoreTxt = [regex]::Split($ScriptTxt, 'Source Reminder ###')[2]
    if ($MoreTxt.Length -ge $fn.Length) {break}
    $_z = [bool](Get-Command -Name $fn -ErrorAction SilentlyContinue)
    Set-Variable -Name $dsrRanVarName -Value $_z
    if (($host.Name).Contains("ISE")) {
        "`nYou have loaded the advanced function `"$fn`""
        "`tUse `"Get-Help`" for information and usage, Ex:`n`tPS C:\> Get-Help $fn -detailed`n"
    }
    ELSE {
        if ($MyInvocation.InvocationName -ne '.') {
            "`nThis advanced function must be dot sourced to run.`n"
            "Load example:`nPS C:\> . `"$ScriptPath`"`n
After loading, use `"Get-Help`" for information and usage, Ex:
PS C:\> Get-Help $fn -detailed`n"
            Pause
        }
    }
}
#endregion Dot Source Reminder ###