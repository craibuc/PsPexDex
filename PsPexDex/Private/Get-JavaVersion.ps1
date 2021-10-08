function Get-JavaVersion
{

    [CmdletBinding()]
    param ()
    
    $Command = "java -version"
    $result = ((Invoke-Expression -Command $Command) *>&1) -join "`n"
    Write-Debug $result

    # create capture group named 'ver' that matches numbers, periods, and underscores within double quotation marks
    $regex = '"(?<ver>[\d\._]+)"'

    if ( $Result -match $regex )
    {
        $Matches['ver']
    }
}