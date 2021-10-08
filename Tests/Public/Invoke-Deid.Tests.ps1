BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsPexDex/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PublicPath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PublicPath $SUT)

}

Describe "Invoke-Deid" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Invoke-Deid'
        }

        Context "siteid" {
            BeforeAll {
                $ParameterName = 'siteid'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "submissionType" {
            BeforeAll {
                $ParameterName = 'submissionType'
            }

            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type [int]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "has a list valid values" -skip {
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

        Context "pidPath" {
            BeforeAll {
                $ParameterName = 'pidPath'
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
            $xmlFile='ABCD_2020-03-04_to_2020-03-14.xml'
            $xmlPath="TestDrive:\$xmlFile"
            New-Item -Path $xmlPath -ItemType File

            $pidFile='PID_ABCD_2020-03-04_to_2020-03-14.txt'
            $pidPath="TestDrive:\$pidFile"
            New-Item -Path $pidPath -ItemType File

            # arrange
            $Expected = @{
                siteid='ABCD'
                submissionType=0
                xmlPath=$xmlPath
                pidPath=$pidPath
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
                    Invoke-Deid -siteid $Expected.siteid -submissionType $Expected.submissionType -xmlPath $Expected.xmlPath -pidPath $Expected.pidPath -study $Expected.study
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

                        $Command -like ("*--deidentify --siteid {0} --submissionType {1} --file {2} --pidtext {3} --study {4}" -f $Expected.siteid, $Expected.submissionType, $Expected.xmlPath, $Expected.pidPath, $Expected.study)
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
                    { Invoke-Deid -siteid $Expected.siteid -submissionType $Expected.submissionType -xmlPath $xmlPath -pidPath $Expected.pidPath -study $Expected.study -ErrorAction Stop } | Should -Throw 'XML file not found'
                }
            }

            Context "When an invalid PID-file path is provided" {        
                It "throws a file-not-found exception" {
                    # arrange
                    $pidPath='\invalid\file\path'

                    # act/assert
                    { Invoke-Deid -siteid $Expected.siteid -submissionType $Expected.submissionType -xmlPath $Expected.xmlPath -pidPath $pidPath -study $Expected.study -ErrorAction Stop } | Should -Throw 'PID file not found'
                }
            }

        }

    }

}