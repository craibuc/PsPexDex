function Verb-Noun 
{

    [CmdletBinding()]
    param ()
    
    # match 
    $regex = '"(?<v>[\d\._]+)"'

    $Result = Invoke-Expression "java -version"

    if ($)
    {
        $true
    }
    else
    {
        $false
    }
}