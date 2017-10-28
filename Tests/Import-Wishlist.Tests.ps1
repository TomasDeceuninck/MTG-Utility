. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Import-Wishlist" {

		BeforeAll {
			Mock Test-Path -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
				return $true
			}
		}

		Context 'Correct Input' {
			BeforeAll {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestWishlist
				}
			}
			It 'Checks if wishlist file exists' {
				{Import-Wishlist -Path $TestWishlistPath} | Should Not Throw
				Assert-MockCalled -CommandName Test-Path -Scope It
			}
			It 'Returns MTGWishlistItem[]' {
				$wishlist = Import-Wishlist -Path $TestWishlistPath
				, $wishlist | Should BeOfType 'System.Object[]'
				$wishlist | ForEach-Object {
					$_.GetType().Name | Should Be 'MTGWishlistItem'
				}
			}
		}

		Context 'Bad Input' {
			It 'Does not load badly formated Wishlists' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestWishlist_BadFormat
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
			It 'Does not load Wishlists with cards in sets that they have not been printed in' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestWishlist_FakePrintings
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
			It 'Does not load Wishlists with non-existing cards' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestWishlist_FakeCards
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
		}
	}
}
