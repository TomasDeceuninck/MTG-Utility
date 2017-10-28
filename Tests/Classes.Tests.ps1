. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe 'MTGCard' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCard]::New()} | Should Throw
			}
			It 'Has a single Name constructor' {
				{[MTGCard]::New($TestWishlist[0])} | Should Not Throw
			}
			It 'Has a Name and Set constructor' {
				{[MTGCard]::New($TestWishlist[0], $TestSets[0])} | Should Not Throw
			}
		}
		Context 'IsUniquelyIdentifiable' {
			It 'Is uniquely identifiable with Name and Set' {
				[MTGCard]::New($TestWishlist[0], $TestSets[0]).IsUniquelyIdentifiable() | Should Be $true
			}
			It 'Is not uniquely identifiable without Name and Set' {
				[MTGCard]::New($TestWishlist[0]).IsUniquelyIdentifiable() | Should Be $false
			}
		}
		Context 'Equals' {
			It 'Confirms Equality between cards with same name and set' {
				[MTGCard]::New($TestWishlist[0], $TestSets[0]).Equals([MTGCard]::New($TestWishlist[0], $TestSets[0])) | Should Be $true
			}
			It 'Confirms Equality between cards with same name and without set' {
				[MTGCard]::New($TestWishlist[0]).Equals([MTGCard]::New($TestWishlist[0])) | Should Be $true
			}
		}
	}
	Describe 'MTGCollectionItem' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCollectionItem]::New()} | Should Throw
			}
			It 'Has a Card and Amount constructor' {
				{[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1)} | Should Not Throw
			}
			It 'Does not allow non uniquely identifiable cards' {
				{[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0]), 1)} | Should Throw
			}
		}
	}
	Describe 'MTGCollection' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCollection]::New()} | Should Throw
			}
			It 'Has a Name and Version constructor' {
				{[MTGCollection]::New('Collection', [System.Version]'0.1')} | Should Not Throw
			}
			It 'Has a Name, Version, and MTGCollectionItem[] constructor' {
				{[MTGCollection]::New('Collection', [System.Version]'0.1', @([MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1), [MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)))} | Should Not Throw
			}
		}
		Context 'Cards' {
			It 'Has a Cards parameter that returns an MTGCollectionItem[]' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @([MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1), [MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)))
				, $collection.Cards | Should BeOfType 'System.Object[]'
				$collection.Cards | ForEach-Object {
					$_.GetType().Name | Should Be 'MTGCollectionItem'
				}
			}
		}
		Context 'Add' {
			It 'Can Add a new card to an empty collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1')
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 0
				{$collection.Add($card)} | Should Not Throw
				$collection.Cards.Count | Should Be 1
				$collection.Cards[0].Card.Equals($card) | Should Be $true
				$collection.Cards[0].Amount | Should be 1
			}
			It 'Can Add multiple copies of a new card to an empty collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1')
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 0
				{$collection.Add($card, 2)} | Should Not Throw
				$collection.Cards.Count | Should Be 1
				$collection.Cards[0].Card.Equals($card) | Should Be $true
				$collection.Cards[0].Amount | Should be 2
			}
			It 'Can Add a new card to an existing collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[2], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.Add($card)} | Should Not Throw
				$collection.Cards.Count | Should Be 3
				$collection.Get($card).Card.Equals($card) | Should Be $true
				$collection.Get($card).Amount | Should be 1
			}
			It 'Can Add a copy of card already in a collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.Add($card)} | Should Not Throw
				$collection.Cards.Count | Should Be 2
				$collection.Get($card).Card.Equals($card) | Should Be $true
				$collection.Get($card).Amount | Should be 2
			}
			It 'Can Add multiple copies of a card already in a collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.Add($card, 2)} | Should Not Throw
				$collection.Cards.Count | Should Be 2
				$collection.Get($card).Card.Equals($card) | Should Be $true
				$collection.Get($card).Amount | Should be 3
			}
		}
		Context 'Remove' {
			It 'Can Remove a card from an existing collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.Remove($card)} | Should Not Throw
				$collection.Cards.Count | Should Be 1
				$collection.Get($card) | Should Be $null
			}
			It 'Can Remove cards from an empty collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1')
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards | Should Be $null
				{$collection.Remove($card)} | Should Not Throw
				$collection.Cards | Should Be $null
				$collection.Get($card) | Should Be $null
			}
			It 'Can Remove multiple copies of a card from an existing collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 2)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.Remove($card, 2)} | Should Not Throw
				$collection.Cards.Count | Should Be 1
				$collection.Get($card) | Should Be $null
			}
		}
		Context 'RemoveAll' {
			It 'Can Remove All copies of a specific card from a collection' {
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 2)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestWishlist[0], $TestSets[0])
				$collection.Cards.Count | Should Be 2
				{$collection.RemoveAll($card)} | Should Not Throw
				$collection.Cards.Count | Should Be 1
				$collection.Get($card) | Should Be $null
			}
			It 'Asks user approval before removing All Cards from the collection' {
				Mock Read-Host -Verifiable {return 'y'}
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 2)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$collection.Cards.Count | Should Be 2
				{$collection.RemoveAll()} | Should Not Throw
				Assert-MockCalled -CommandName Read-Host -Exactly -Times 1 -Scope It
				$collection.Cards | Should Be $null
			}
			It 'Does not asks user approval before removing All Cards from the collection when confirmation is given' {
				Mock Read-Host -Verifiable {return 'y'}
				$collection = [MTGCollection]::New('Collection', [System.Version]'0.1', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[0]), 2)
						[MTGCollectionItem]::New([MTGCard]::New($TestWishlist[0], $TestSets[2]), 1)
					))
				$collection.Cards.Count | Should Be 2
				{$collection.RemoveAll($true)} | Should Not Throw
				Assert-MockCalled -CommandName Read-Host -Exactly -Times 0 -Scope It
				$collection.Cards | Should Be $null
			}
		}
	}
}
