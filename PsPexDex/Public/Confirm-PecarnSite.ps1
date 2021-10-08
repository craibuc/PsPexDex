<#
.SYNOPSIS
Registers 

.PARAMETER siteid
The four-letter, site or location id of the entity submitting data.

.PARAMETER pin
The six-digit, numerical value supplied by the DCC.

.PARAMETER publickey
Located in $env:APPDATA\pexdex\registry.[siteid]\.ssh\id-rsa.pub

.PARAMETER study
Valid values: registry

.EXAMPLE
PS> $siteid = 'ABCD'

PS> $publickey = Get-Content $env:APPDATA\pexdex\registry.$siteid\.ssh\id-rsa.pub -Raw

# remove ending new-line character
PS> $publickey = $publickey -replace "`n", ''

PS> Confirm-PecarnSite -siteid $siteid -pin 123456 -publickey $publickey -study 'registry'

Retrieve the public key and store it in a variable, then confirm the site's registration.

#>
function Confirm-PecarnSite {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteid,

        [Parameter(Mandatory)]
        [string]$pin,

        [Parameter(Mandatory)]
        [string]$publickey,

        [Parameter(Mandatory)]
        [ValidateSet('registry')]
        [string]$study
    )
    
    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --spring.profiles.active=error --confirmregister --siteid $siteid --pin $pin --publickey '$publickey' -l $study"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess("$siteid",'confirm'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}