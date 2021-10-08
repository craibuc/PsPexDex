BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PrivatePath = Join-Path $ProjectDirectory "/PsPexDex/Private/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PrivatePath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PrivatePath $SUT)

}

Describe "Invoke-JavaCommand" {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Invoke-JavaCommand'
        }

        Context "Argument" {
            BeforeAll {
                $ParameterName = 'Argument'
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

        Context "When the mandatory parameters are supplied" {
    
            BeforeEach {
                # arrange
                $Argument = '-version'

                Mock Invoke-Expression

                # act
                Invoke-JavaCommand -Argument $Argument
            }

            It "calls Invoke-Expression with the expected command" {
                # assert
                Assert-MockCalled Invoke-Expression -ParameterFilter {
                    $Command -eq "java $Argument"
                }
            }
        }

    }
}