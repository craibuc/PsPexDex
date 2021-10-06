<#
.SYNOPSIS
Registers 

.PARAMETER siteid
The four-letter, site or location id of the entity submitting data.

.PARAMETER pin

.PARAMETER publickey

.EXAMPLE
PS> Confirm-PecarnSite -siteid 'ABCD' -pin 123456 --publickey ''

#>
function Confirm-PecarnSite {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteid,
        [Parameter(Mandatory)]
        [string]$pin,
        [Parameter(Mandatory)]
        [string]$publickey
    )
    
    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --confirmregister --siteid $siteid --pin $pin --publickey $publickey --spring.profiles.active=error"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess("$siteid",'confirm'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}