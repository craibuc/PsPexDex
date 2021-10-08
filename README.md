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
## pexdexCLI help text
Requires Java "11" or greater.

```
C:\Program Files\PEXDEX> java '-Dproperties.dir=.' -jar .\CLI\pexdexCLI.jar --help
usage: pexdexCLI [-a <arg>] [-c] [-d] [-e <arg>] [-f <arg>] [-i <arg>] [-k <arg>] [-l <arg>] [-p <arg>] [-r] [-s] [-t <arg>] [-u <arg>] [-v] [-y <arg>]

 -c,--confirmregister        Confirm Register the site. require - Pin, SiteId and sftp certificate
 -d,--deidentify             Deidentify the XML. require - XML file path, the pid.txt file path, the submissiontype and the SiteId incase the submissiontype is 0
 -r,--register               Register the site. require - siteId, emailAddress
 -s,--submit                 Submit the deid file to Utah DCC. require - the deidXML file path and the siteId
 
 -a,--apitoken <arg>         APIToken
 -e,--email <arg>            The email address to register
 -f,--file <arg>             The XML filepath for validate or deid options
 -i,--siteid <arg>           Four letter SiteId for the site
 -k,--publickey <arg>        SFTP Public key
 -l,--study <arg>            Study for the command - pedscreen or registry
 -p,--pin <arg>              Four digit pin sent via email from Utah DCC
 -t,--pidtxt <arg>           The pid text filepath for deid options
 -u,--userid <arg>           User ID
 -v,--validate               Validate the xml against pedscreen XSD. require - XML file path
 -y,--submissiontype <arg>   Send value 1 to Deid or 0 for No Deid
```

## Dependencies
- [Psake](https://github.com/psake/psake) - build automation
- [Pester](https://pester.dev/) - unit tests

## Contributors
- [Craig Buchanan](https://github.com/craibuc)
