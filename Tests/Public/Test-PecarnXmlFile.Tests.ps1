BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsPexDex/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PublicPath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PublicPath $SUT)

}

Describe "Test-PecarnXmlFile" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Test-PecarnXmlFile'
        }

        Context "siteId" {
            BeforeAll {
                $ParameterName = 'siteId'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "xmlPath" {
            BeforeAll {
                $ParameterName = 'xmlPath'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "Usage" {

        BeforeAll {
            # arrange
            $xmlFile='ABCD_2020-03-04_to_2020-03-14.xml'
            $xmlPath="TestDrive:\$xmlFile"
            New-Item -Path $xmlPath -ItemType File

            $Expected = @{
                siteId='ABCD'
                xmlPath=$xmlPath
                PexDexDirectory='C:\Program Files\PEXDEX'    
            }
        }

        Context "When the mandatory parameters are supplied" {
    
            BeforeEach {
                # arrange
                Mock Push-Location
                Mock Invoke-Expression
                Mock Pop-Location

                # act
                Test-PecarnXmlFile -siteid $Expected.siteid -xmlPath $Expected.xmlPath
            }

            It "changes to the directory that contains the PexDex EXE" {
                # assert
                Assert-MockCalled Push-Location -ParameterFilter {
                    $Path -eq $Expected.PexDexDirectory
                }
            }

            It "invokes PexDex's CLI with the expected values" {
                # assert
                Assert-MockCalled Invoke-Expression -ParameterFilter {
                    Write-Debug "Command: $Command"
                    $Command -like ("*--validate --siteid {0} --file {1}" -f $Expected.siteid, $Expected.xmlPath)
                }
            }

            It "restores the original directory" {
                # assert
                Assert-MockCalled Pop-Location
            }

        }

    }
}