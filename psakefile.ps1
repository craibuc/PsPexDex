<#
.EXAMPLE
PS> Invoke-Psake

Name    Alias Depends On Default Description
----    ----- ---------- ------- -----------
List                        True List all tasks
Pester                           Run Pester with specified configuration
Symlink                          Symlink development folder to canonical, Modules folder

List of tasks that can be run by Psake.

.EXAMPLE
PS> Invoke-Psake Pester

Runs all unit tests.

.EXAMPLE
PS> Invoke-Psake Symlink

Creates a symbolic link from /PowerShell/Development/PsPexDex/PsPexDex in the profile's /PowerShell/Modules directory.

.NOTES

Dependencies:
- Psake module
- Pester module
#>

FormatTaskName "---------- {0} ----------"

Task default -depends List

Task List -description "List all tasks" {
    Invoke-psake -docs
}

Task Symlink -description "Symlink development folder to canonical, Modules folder" {

    # https://stackoverflow.com/questions/44703646/determine-the-os-version-linux-and-windows-from-powershell#44703836
    $Modules = $IsWindows ? "$HOME\Documents\PowerShell\Modules" : "$HOME/.local/share/powershell/Modules"

    $Link = Join-Path $Modules 'PsPexDex'
    Write-Host "Link: $Link"

    $Target = Resolve-Path "$PSScriptRoot\PsPexDex"
    Write-Host "Target:$Target"

    New-Item -Path $Link -ItemType SymbolicLink -Value $Target

}

Task Pester -description "Run Pester with specified configuration" {

    $Configuration = [PesterConfiguration]::Default
    $Configuration.Output.Verbosity = 'Detailed'

    Invoke-Pester -Configuration $Configuration

}