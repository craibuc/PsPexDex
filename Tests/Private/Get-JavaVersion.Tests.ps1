BeforeAll {

    # /Paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PrivatePath = Join-Path $ProjectDirectory "/PsPexDex/Private/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    $Path = Join-Path $PrivatePath $SUT
    Write-Host "Path: $Path"

    . (Join-Path $PrivatePath $SUT)

}

Describe "Get-JavaVersion" {

    Context "Usage" {

        Context "When the mandatory parameters are supplied" {
    
            BeforeEach {
                # arrange
                Mock Invoke-Expression -MockWith {
                    'openjdk version "11.0.3" 2019-04-16
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.3+7)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.3+7, mixed mode)'
                }

                # act
                $actual = Get-JavaVersion
            }

            It "gets the text response from 'java -version'" {
                # assert
                Assert-MockCalled Invoke-Expression -ParameterFilter {
                    $Command -eq 'java -version'
                }
            }

            It "extracts the version text" {
                $actual | Should -Be '11.0.3'
            }
        }

    }
}