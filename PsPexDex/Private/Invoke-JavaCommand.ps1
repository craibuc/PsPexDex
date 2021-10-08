function Invoke-JavaCommand
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Argument
    )

    Write-Debug "Argument: $Argument"
    
    Invoke-Expression -Command "java $Argument"

}