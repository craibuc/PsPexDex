BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsPexDex/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PublicPath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PublicPath $SUT)

}

Describe "Submit-PecarnXmlFile" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Submit-PecarnXmlFile'
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

        Context "study" {
            BeforeAll {
                $ParameterName = 'study'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "has a list valid values" -skip {
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
                study='registry'
                PexDexDirectory='C:\Program Files\PEXDEX'    
            }
        }

        Context "Valid" {

            Context "When the mandatory parameters are supplied" {
    
                BeforeEach {
                    # arrange
                    Mock Push-Location
                    Mock Invoke-Expression
                    Mock Pop-Location
    
                    # act
                    Submit-PecarnXmlFile -siteid $Expected.siteid -xmlPath $Expected.xmlPath -study $Expected.study
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
                        $Command -like ("*--submit --siteid {0} --file {1} --study {2}" -f $Expected.siteid, $Expected.xmlPath, $Expected.study)
                    }
                }
    
                It "restores the original directory" {
                    # assert
                    Assert-MockCalled Pop-Location
                }
    
            }

        }

        Context "Invalid" {

            Context "When an invalid XML-file path is provided" {        
                It "throws a file-not-found exception" {
                    # arrange
                    $xmlPath='\invalid\file\path'

                    # act/assert
                    { Submit-PecarnXmlFile -siteid $Expected.siteid -xmlPath $xmlPath -study $Expected.study -ErrorAction Stop } | Should -Throw 'XML file not found'
                }
            }

        }
    }
}