. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Import-Collection" {

		BeforeAll {
			Mock Test-Path -Verifiable -ParameterFilter {$Path -eq $TestImportCollectionPath} {
				return $true
			}
		}

		Context 'Correct Input' {
			BeforeAll {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestImportCollectionPath} {
					return $TestImportCollection
				}
			}
			It 'Checks if wishlist file exists' {
				{Import-Collection -Path $TestImportCollectionPath -Name $TestImportCollectionName} | Should Not Throw
				Assert-MockCalled -CommandName Test-Path -Scope It
			}
			It 'Returns MTGCollection' {
				$collection = Import-Collection -Path $TestImportCollectionPath -Name $TestImportCollectionName
				$collection.GetType().Name | Should Be 'MTGCollection'
				$collection.Name | Should Be $TestImportCollectionName
				$collection.Version | Should BeOfType 'System.Version'
				$collection.Version -eq $SETTINGS.Files.Collection.CurrentVersion | Should Be $true
			}
		}

		Context 'Bad Input' {
			It 'Does not load Collections with cards without sets' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestImportCollection_Incomplete
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
			It 'Does not load badly formated Collection' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestImportCollection_BadFormat
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
			It 'Does not load Collection with cards in sets that they have not been printed in' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestImportCollection_FakePrintings
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
			It 'Does not load Collection with non-existing cards' {
				Mock Get-Content -Verifiable -ParameterFilter {$Path -eq $TestWishlistPath} {
					return $TestImportCollection_FakeCards
				}
				{Import-Wishlist -Path $TestWishlistPath} | Should Throw
			}
		}
	}
}
