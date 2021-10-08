<#
.SYNOPSIS
 

.PARAMETER siteId
The four-letter, site or location id of the entity submitting data.

.PARAMETER xmlPath
Path to the XML file.

.EXAMPLE
PS> Test-PecarnXmlFile -siteId 'ABCD' -xmlPath \path\to\output\ABCD\ABCD_2020-03-04_to_2020-03-14.xml

#>
function Test-PecarnXmlFile {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteId,

        [Parameter(Mandatory)]
        [string]$xmlPath
    )
    
    if ( (Test-Path -Path $xmlPath) -eq $false )
    {
        throw System.IO.FileNotFoundException::new("XML file not found", $xmlPath)
    }

    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --spring.profiles.active=error --validate --siteid $siteId --file $xmlPath"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess("$siteId/$xmlPath",'validate'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}