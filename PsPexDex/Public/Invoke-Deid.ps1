<#
.SYNOPSIS
De-identify the XML file.

.PARAMETER siteId
The four-letter, site or location id of the entity submitting data.

.PARAMETER submissionType
0 = No Deid or 1 = Deid

.PARAMETER xmlPath
Path to the XML file.

.PARAMETER pidPath
Path to the PID file.

.PARAMETER study
Valid values: pedscreen, registry

.EXAMPLE
PS> Invoke-Deid -siteId 'ABCD' -submissionType 0 -xmlPath \path\to\output\ABCD\ABCD_2020-03-04_to_2020-03-14.xml -pidPath \path\to\output\ABCD\PID_ABCD_2020-03-04_to_2020-03-14.txt --study registry

#>
function Invoke-Deid {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$siteId,

        [Parameter(Mandatory)]
        [ValidateSet(0,1)]
        [int]$submissionType,

        [Parameter(Mandatory)]
        [string]$xmlPath,

        [Parameter(Mandatory)]
        [string]$pidPath,

        [Parameter(Mandatory)]
        [ValidateSet('pedscreen','registry')]
        [string]$study
    )
    
    Write-Debug "xmlPath: $xmlPath"
    if ( (Test-Path -Path $xmlPath) -eq $false )
    {
        throw [System.IO.FileNotFoundException]::new("XML file not found", $xmlPath)
    }

    Write-Debug "pidPath: $pidPath"
    if ( (Test-Path -Path $pidPath) -eq $false )
    {
        throw [System.IO.FileNotFoundException]::new("PID file not found", $pidPath)
    }

    $PexDexDirectory = $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory ? $MyInvocation.MyCommand.Module.PrivateData.PexDexDirectory : 'C:\Program Files\PEXDEX'
    Write-Debug "PexDexDirectory: $PexDexDirectory"

    Push-Location -Path $PexDexDirectory

    $Command = "java ""-Dproperties.dir=C:\Program Files\PEXDEX"" -jar .\CLI\pexdexCLI.jar --spring.profiles.active=error --deidentify --siteid $siteid --submissiontype $submissionType --file $xmlPath --pidtext $pidPath --study $study"
    Write-Debug "Command: $Command"

    if ($PSCmdlet.ShouldProcess("$siteid/$xmlPath",'de-identify'))
    {
        Invoke-Expression -Command $Command
    }
    
    Pop-Location

}