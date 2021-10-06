# PsPexDex
PowerShell wrapper of the U of UT's Data Coordinating Center's PexDex application

## Installation

### Dependencies
```powershell
Install-Module Pester
Install-Moduule Psake
```

### Module (from Github)
Install the module's source code to `~\Documents\PowerShell\Development\PsPexDex`
```powershell
cd ~\Documents\Powershell
mkdir Development
cd Development
git clone git@github.com:craibuc/PsPexDex.git
```

### Symbolic link
Create a symbolic link in `~\Documents\PowerShell\Modules` to `~\Documents\PowerShell\Development\PsPexDex\PsPexDex`.  This excludes the development-specific code like tests.

#### Manually
```powershell
New-Item -Path ~\Documents\PowerShell\Modules\PsPexDex -ItemType SymbolicLink -Value ~\Documents\PowerShell\Development\PsPexDex\PsPexDex
```
-- OR --

#### Using Psake
```powershell
Invoke-Psake symlink
```
## Usage

Import the module (done once per session)
```powershell
Import-Module PsPexDex
```

### Register-PecarnSite
```powershell
Register-PecarnSite -siteid 'ABCD' -email 'first.last@domain.tld'
```

### Confirm-PecarnSite
After registering the site, an email will be sent with the site's PIN.

The site's public key is located in `~\AppData\Roaming\pexdex\registry.ABCD\.ssh\id-rsa.pub`
```powershell
Confirm-PecarnSite -siteid 'ABCD' -pin 123456 -publickey 'ssh-rsa ...'
```

## Dependencies
- [Psake](https://github.com/psake/psake) - build automation
- [Pester](https://pester.dev/) - unit tests

## Contributors
- [Craig Buchanan](https://github.com/craibuc)
