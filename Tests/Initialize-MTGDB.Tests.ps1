. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1

	Describe "Initialize-MTGDB" {

		BeforeEach{
			try {
				Remove-Variable -Name MTGDB -Scope Global -ErrorAction Ignore
				Remove-Variable -Name MTGSets -Scope Global -ErrorAction Ignore
			} catch [System.Management.Automation.ItemNotFoundException] {
				continue # This is good, it should not exist
			}
		}

		Mock Get-Content -Verifiable -ParameterFilter {$Path -eq (Join-Path $moduleRoot $SETTINGS.Resources.MTGJson.Path)} {
			Write-Output $TestJson
		}

		It "Gets the content of the MTGJson" {
			{ Initialize-MTGDB } | Should Not Throw
			Assert-MockCalled -CommandName Get-Content -Exactly -Times 1 -Scope It
		}

		It "Does not re-initialize MTGDB if the variables already exists" {
			Set-Variable -Name MTGDB -Scope Global -Value 'Test'
			{ Initialize-MTGDB } | Should Not Throw
			Assert-MockCalled -CommandName Get-Content -Exactly -Times 0 -Scope It
		}

		It "Does not re-initialize MTGSets if the variables already exists" {
			Set-Variable -Name MTGSets -Scope Global -Value 'Test'
			{ Initialize-MTGDB } | Should Not Throw
			$Global:MTGSets | Should Be 'Test'
		}

		It "Creates the MTGDB global variable" {
			$Global:MTGDB | Should Throw
			Initialize-MTGDB
			, $Global:MTGDB | Should BeOfType 'System.Object[]'
		}

		It "Creates the MTGSets global variable" {
			try {
				Remove-Variable -Name MTGSets -Scope Global -ErrorAction SilentlyContinue
			} catch [System.Management.Automation.ItemNotFoundException] {
				# This is good, it should not exist
			}
			$Global:MTGSets | Should Throw
			Initialize-MTGDB
			, $Global:MTGSets | Should BeOfType 'System.Object[]'
		}

		Context "Created variables" {
			BeforeEach {
				try {
					Remove-Variable -Name MTGDB -Scope Global -ErrorAction Ignore
					Remove-Variable -Name MTGSets -Scope Global -ErrorAction Ignore
				} catch [System.Management.Automation.ItemNotFoundException] {
					continue # This is good, it should not exist
				}
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq (Join-Path $moduleRoot $SETTINGS.Resources.MTGJson.Path)} {
					Write-Output $TestJson
				}
				Initialize-MTGDB
				[System.Collections.ArrayList]$setsArray = $TestSets
			}

			It "Created the MTGDB variable with the correct amount of cards" {
				$Global:MTGDB.Count | Should Be $TestCardCount
			}

			It "Created the MTGSets variable with the correct amount of sets" {
				$areEqual = $true
				foreach ($set in $Global:MTGSets) {
					if ($set -in $setsArray) {
						$setsArray.Remove($set)
					} else {
						$areEqual = $false
					}
				}
				if (!$areEqual -and ($setsArray.Count -gt 0)) {
					$areEqual = $false
				}
				$areEqual | Should Be $true
			}
		}
		
	}
}
