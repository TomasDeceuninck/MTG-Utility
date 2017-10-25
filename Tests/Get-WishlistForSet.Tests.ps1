. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Get-WishlistForSet" {

		BeforeAll {
			Mock Get-Content -Verifiable -ParameterFilter {$Path -eq (Join-Path $moduleRoot $SETTINGS.Resources.MTGJson.Path)} {
				Write-Output $TestJson
			}
		}

		BeforeEach {
			try {
				Remove-Variable -Name MTGDB -Scope Global -ErrorAction Ignore
				Remove-Variable -Name MTGSets -Scope Global -ErrorAction Ignore
			} catch [System.Management.Automation.ItemNotFoundException] {
				continue # This is good, it should not exist
			}
		}

		It "Finds card from wishlist in Set" {
			$results = Get-WishlistForSet -Wishlist $TestWishlist -Set 'MM2'
			, $results | Should BeOfType 'System.Management.Automation.PSCustomObject'
			$results.Name | Should BeLike 'Lightning Bolt'
		}

		It "Finds multiple cards from wishlist in set" {
			$results = Get-WishlistForSet -Wishlist $TestWishlist -Set 'MM3'
			, $results | Should BeOfType 'System.Object[]'
			$results.Count | Should Be 2
			$shouldFind = @('Serum Visions', 'Liliana of the Veil')
			$allFound = $true
			foreach ($result in $results) {
				if ($result.Name -notin $shouldFind) {
					$allFound = $false
				}
			}
			$allFound | Should Be $true
		}

		It "Finds no cards from wishlist in set" {
			$results = Get-WishlistForSet -Wishlist $TestWishlist -Set 'RTR'
			$results | Should BeNullOrEmpty
		}
		
	}
}
