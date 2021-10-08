<#
.SYNOPSIS
Registers 

.PARAMETER siteid
The four-letter, site or location id of the entity submitting data.

.PARAMETER xmlPath
Path to the XML file.

.EXAMPLE
PS> Submit-PecarnXmlFile -siteid 'ABCD' -xmlPath \path\to\output\ABCD\ABCD_2020-03-04_to_2020-03-14.xml

#>
function Submit-PecarnXmlFile {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteid,

        [Parameter(Mandatory)]
        [string]$xmlPath,

        [Parameter()]
        [string]$type
    )
    
    # if xmlPath doesn't exists, throw exception
    if ( (Test-Path -Path $xmlPath) -eq $false )
    {
        throw [System.IO.FileNotFoundException]::new("XML file not found", $xmlPath)
    }
    
    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --spring.profiles.active=error --validate --siteid $siteid --file $xmlPath"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess("$siteid/$email",'register'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}