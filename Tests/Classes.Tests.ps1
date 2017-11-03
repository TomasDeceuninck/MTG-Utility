. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe 'MTGCard' -Tags 'Clean' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCard]::New()} | Should Throw
			}
			It 'Has a single Name constructor' {
				{
					$card = [MTGCard]::New($TestCardNames[0])
					$card.Name | Should Be $TestCardNames[0]
					$card.Set | Should Be $null
				} | Should Not Throw
			}
			It 'Has a Name and Set constructor' {
				{
					$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
					$card.Name | Should Be $TestCardNames[0]
					$card.Set | Should Be $TestSets[0]
				} | Should Not Throw
			}
		}
		Context 'IsUniquelyIdentifiable' {
			It 'Is uniquely identifiable with Name and Set' {
				[MTGCard]::New($TestCardNames[0], $TestSets[0]).IsUniquelyIdentifiable() | Should Be $true
			}
			It 'Is not uniquely identifiable without Name and Set' {
				[MTGCard]::New($TestCardNames[0]).IsUniquelyIdentifiable() | Should Be $false
			}
		}
		Context 'IsInitialized' {
			It 'Is initialized if Name, Info, and ColorID are set' {
				#ToDo
			}
			It 'Is not initialized if Name not set' {
				#ToDo
			}
			It 'Is not initialized if Info not set' {
				#ToDo
			}
			It 'Is not initialized if ColorID not set' {
				#ToDo
			}
		}
		Context 'Equals' {
			It 'Confirms Equality between cards with same name and set' {
				[MTGCard]::New($TestCardNames[0], $TestSets[0]).Equals([MTGCard]::New($TestCardNames[0], $TestSets[0])) | Should Be $true
			}
			It 'Confirms Equality between cards with same name and without set' {
				[MTGCard]::New($TestCardNames[0]).Equals([MTGCard]::New($TestCardNames[0])) | Should Be $true
			}
		}
		Context 'ToString' {
			It 'Converts MTGCard object to a string like "<CardName> [<SetCode>]"' {
				#ToDo
			}
		}
	}
	Describe 'MTGCollectionItem' -Tags 'Clean' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCollectionItem]::New()} | Should Throw
			}
			It 'Has a Card and Amount constructor' {
				{
					$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
					$amount = 1
					$item = [MTGCollectionItem]::New($card , $amount)
					$item.Card | Should Be $card
					$item.Amount | Should Be $amount
				} | Should Not Throw
			}
			It 'Does not allow non uniquely identifiable cards' {
				{[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0]), 1)} | Should Throw
			}
		}
	}
	Describe 'MTGCollection' -Tags 'Clean' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGCollection]::New()} | Should Throw
			}
			It 'Has a Name constructor' {
				{
					$name = 'Collection'
					$collection = [MTGCollection]::New($name)
					$collection.Name | Should Be $name
					$collection.Items | Should Be $null
				} | Should Not Throw
			}
			It 'Has a Name and MTGCollectionItem[] constructor' {
				{
					$name = 'Collection'
					$items = @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					)
					$collection = [MTGCollection]::New($name, $items)
					$collection.Name | Should Be $name
					$collection.Items | Should Be $items
				} | Should Not Throw
			}
		}
		Context 'Add' {
			It 'Can Add a new card to an empty collection' {
				$collection = [MTGCollection]::New('Collection')
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 0
				{$collection.Add($card)} | Should Not Throw
				$collection.Items.Count | Should Be 1
				$collection.Items[0].Card.Equals($card) | Should Be $true
				$collection.Items[0].Amount | Should be 1
			}
			It 'Can Add multiple copies of a new card to an empty collection' {
				$collection = [MTGCollection]::New('Collection')
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 0
				{$collection.Add($card, 2)} | Should Not Throw
				$collection.Items.Count | Should Be 1
				$collection.Items[0].Card.Equals($card) | Should Be $true
				$collection.Items[0].Amount | Should be 2
			}
			It 'Can Add a new card to an existing collection' {
				$collection = [MTGCollection]::New('Collection', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestCardNames[2], $TestSets[0])
				$collection.Items.Count | Should Be 2
				{$collection.Add($card)} | Should Not Throw
				$collection.Items.Count | Should Be 3
				# $collection.Get($card).Card.Equals($card) | Should Be $true
				# $collection.Get($card).Amount | Should be 1
			}
			It 'Can Add a copy of card already in a collection' {
				$collection = [MTGCollection]::New('Collection', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 2
				{$collection.Add($card)} | Should Not Throw
				$collection.Items.Count | Should Be 2
				# $collection.Get($card).Card.Equals($card) | Should Be $true
				# $collection.Get($card).Amount | Should be 2
			}
			It 'Can Add multiple copies of a card already in a collection' {
				$collection = [MTGCollection]::New('Collection', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 2
				{$collection.Add($card, 2)} | Should Not Throw
				$collection.Items.Count | Should Be 2
				# $collection.Get($card).Card.Equals($card) | Should Be $true
				# $collection.Get($card).Amount | Should be 3
			}
		}
		Context 'Remove' {
			It 'Can Remove a card from an existing collection' {
				$collection = [MTGCollection]::New('Collection', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 1)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 2
				{$collection.Remove($card)} | Should Not Throw
				$collection.Items.Count | Should Be 1
				# $collection.Get($card) | Should Be $null
			}
			It 'Can Remove cards from an empty collection' {
				$collection = [MTGCollection]::New('Collection')
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items | Should Be $null
				{$collection.Remove($card)} | Should Not Throw
				$collection.Items | Should Be $null
				# $collection.Get($card) | Should Be $null
			}
			It 'Can Remove multiple copies of a card from an existing collection' {
				$collection = [MTGCollection]::New('Collection', @(
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 2)
						[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
					))
				$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
				$collection.Items.Count | Should Be 2
				{$collection.Remove($card, 2)} | Should Not Throw
				$collection.Items.Count | Should Be 1
				# $collection.Get($card) | Should Be $null
			}
		}
		# Remove all does not seem relevant but only dangerous?
			# Context 'RemoveAll' {
			# 	It 'Can Remove All copies of a specific card from a collection' {
			# 		$collection = [MTGCollection]::New('Collection', @(
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 2)
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
			# 			))
			# 		$card = [MTGCard]::New($TestCardNames[0], $TestSets[0])
			# 		$collection.Cards.Count | Should Be 2
			# 		{$collection.RemoveAll($card)} | Should Not Throw
			# 		$collection.Cards.Count | Should Be 1
			# 		$collection.Get($card) | Should Be $null
			# 	}
			# 	It 'Asks user approval before removing All Cards from the collection' {
			# 		Mock Read-Host -Verifiable {return 'y'}
			# 		$collection = [MTGCollection]::New('Collection', @(
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 2)
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
			# 			))
			# 		$collection.Cards.Count | Should Be 2
			# 		{$collection.RemoveAll()} | Should Not Throw
			# 		Assert-MockCalled -CommandName Read-Host -Exactly -Times 1 -Scope It
			# 		$collection.Cards | Should Be $null
			# 	}
			# 	It 'Does not asks user approval before removing All Cards from the collection when confirmation is given' {
			# 		Mock Read-Host -Verifiable {return 'y'}
			# 		$collection = [MTGCollection]::New('Collection', @(
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[0]), 2)
			# 				[MTGCollectionItem]::New([MTGCard]::New($TestCardNames[0], $TestSets[2]), 1)
			# 			))
			# 		$collection.Cards.Count | Should Be 2
			# 		{$collection.RemoveAll($true)} | Should Not Throw
			# 		Assert-MockCalled -CommandName Read-Host -Exactly -Times 0 -Scope It
			# 		$collection.Cards | Should Be $null
			# 	}
			# }
		#
	}
	Describe 'MTGWishlistItem' {
		Context 'Constructor' {
			It 'Has no empty constructor' {
				{[MTGWishlistItem]::New()} | Should Throw
			}
			It 'Has a single Name constructor' {
				{
					$item = [MTGWishlistItem]::New($TestCardNames[0])
					$item.Name | Should Be $TestCardNames[0]
					$item.Amount | Should Be 1
					$item.Set | Should Be $null
				} | Should Not Throw
			}
			It 'Has a Name and Set constructor' {
				{
					$item = [MTGWishlistItem]::New($TestCardNames[0], $TestSets[0])
					$item.Name | Should Be $TestCardNames[0]
					$item.Amount | Should Be 1
					$item.Set | Should Be $TestSets[0]
				} | Should Not Throw
			}
			It 'Has a Name and Amount constructor' {
				{
					$item = [MTGWishlistItem]::New($TestCardNames[0], 2)
					$item.Name | Should Be $TestCardNames[0]
					$item.Amount | Should Be 2
					$item.Set | Should Be $null
				} | Should Not Throw
			}
			It 'Has a Name, Amount, and Set constructor' {
				{
					$item = [MTGWishlistItem]::New($TestCardNames[0], 2, $TestSets[0])
					$item.Name | Should Be $TestCardNames[0]
					$item.Amount | Should Be 2
					$item.Set | Should Be $TestSets[0]
				} | Should Not Throw
			}
		}
	}
}
