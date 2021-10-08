BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsPexDex/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PublicPath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PublicPath $SUT)

}

Describe "Confirm-PecarnSite" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Confirm-PecarnSite'
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

        Context "pin" {
            BeforeAll {
                $ParameterName = 'pin'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "publickey" {
            BeforeAll {
                $ParameterName = 'publickey'
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
            $Expected = @{
                siteid='ABCD'
                pin=123456
                publickey='ssh-rsa 8edff50a-d0e7-49b5-aa43-3c5255a7cf50'
                study='registry'
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
                Confirm-PecarnSite -siteid $Expected.siteid -pin $Expected.pin -publickey $Expected.publickey -study $Expected.study
            }

            It "changes to the directory that contains the PexDex EXE" {
                # assert
                Assert-MockCalled Push-Location -ParameterFilter {
                    Write-Debug "Path: $Path"
                    $Path -eq $Expected.PexDexDirectory
                }
            }

            It "invokes PexDex's CLI with the expected values" {
                # assert
                Assert-MockCalled Invoke-Expression -ParameterFilter {
                    Write-Debug "Command: $Command"

                    $Command -like ("*--confirmregister --siteid {0} --pin {1} --publickey '{2}' -l {3}*" -f $Expected.siteid, $Expected.pin, $Expected.publickey, $Expected.study)
                }
            }

            It "restores the original directory" {
                # assert
                Assert-MockCalled Pop-Location
            }

        }

    }
}