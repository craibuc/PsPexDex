<#
.SYNOPSIS
Registers 

.PARAMETER siteid
The four-letter, site or location id of the entity submitting data.

.PARAMETER email
The email address of the individual that will perform the data submissions.

.EXAMPLE
PS> Register-PecarnSite -siteid 'ABCD' -email 'first.last@domain.tld'

#>
function Register-PecarnSite {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteid,
        [Parameter(Mandatory)]
        [string]$email
    )
    
    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --siteid $siteid --email $email --spring.profiles.active=error"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess('target','action'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}