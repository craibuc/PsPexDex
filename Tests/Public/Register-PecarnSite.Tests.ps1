BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsPexDex/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PublicPath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PublicPath $SUT)

}

Describe "Register-PecarnSite" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Register-PecarnSite'
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

        Context "email" {
            BeforeAll {
                $ParameterName = 'email'
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
            $Expected = @{
                siteid='ABCD'
                email='first.last@domain.tld'
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
                Register-PecarnSite -siteid $Expected.siteid -email $Expected.email
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
                    Write-Debug "siteid: $siteid"
                    Write-Debug "email: $email"

                    $Command -like ("*--register --siteid {0} --email {1}*" -f $Expected.siteid, $Expected.email)
                }
            }

            It "restores the original directory" {
                # assert
                Assert-MockCalled Pop-Location
            }

        }

    }
}