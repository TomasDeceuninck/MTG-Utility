. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Get-WishlistCardsInSet" {

		BeforeAll {
			Mock Get-Content -Verifiable -ParameterFilter {$Path -eq (Join-Path $moduleRoot $SETTINGS.Resources.MTGJson.Path)} {
				Write-Output $TestJson
			}
			Mock Test-Path -Verifiable -ParameterFilter {$Path -eq $testWishlistPath} {
				return $true
			}
			Mock Import-Wishlist -ParameterFilter {$Path -eq $TestWishlistPath} {
				return @(
					[MTGWishlistItem]::New('Lightning Bolt','pMPR')
					[MTGWishlistItem]::New('Liliana of the Veil',2)
					[MTGWishlistItem]::New('Serum Visions','MM3')
					[MTGWishlistItem]::New('Thought-Knot Seer')
				)
			}
		}

		It 'Accepts Input from pipeline' {
			$SetToTest = 'MM2'
			{Import-Wishlist -Path $TestWishlistPath | Get-WishlistCardsInSet -Set $SetToTest} | Should Not Throw
		}

		It "Finds card from wishlist in Set" {
			$SetToTest = 'MM2'
			$CardsToFind = @('Lightning Bolt')
			$wishlist = Get-WishlistCardsInSet -Wishlist (Import-Wishlist -Path $TestWishlistPath) -Set $SetToTest
			# , $wishlist | Should BeOfType 'System.Object[]'
			$wishlist | ForEach-Object {
				$_.GetType().Name | Should Be 'MTGCard'
				$_.Name -in $CardsToFind | Should Be $true
			}
		}

		It "Finds multiple cards from wishlist in set" {
			$SetToTest = 'MM3'
			$CardsToFind = @('Serum Visions', 'Liliana of the Veil')
			$wishlist = Get-WishlistCardsInSet -Wishlist (Import-Wishlist -Path $TestWishlistPath) -Set $SetToTest
			,$wishlist | Should BeOfType 'System.Object[]'
			$wishlist | ForEach-Object {
				$_.GetType().Name | Should Be 'MTGCard'
				$_.Name -in $CardsToFind | Should Be $true
			}
			$allFound = $true
			foreach($cardToFind in $CardsToFind){
				if ($cardToFind -notin ($wishlist | Select-Object -ExpandProperty Name)) {
					$allFound = $false
				}
			}
			$allFound | Should Be $true
		}

		It "Finds no cards from wishlist in set" {
			$SetToTest = 'RTR'
			$wishlist = Get-WishlistCardsInSet -Wishlist (Import-Wishlist -Path $TestWishlistPath) -Set $SetToTest
			$wishlist | Should BeNullOrEmpty
		}
		
	}
}
