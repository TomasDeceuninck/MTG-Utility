. $PSScriptRoot\_InitializeTestEnvironment.ps1
InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	Describe "Export-Collection" {

		$testCollection = [MTGCollection]::New($TestCollectionName,@(
			[MTGCollectionItem]::New([MTGCard]::New('Abrupt Decay','RTR'),2)
			[MTGCollectionItem]::New([MTGCard]::New('Lightning Bolt','M11'),1)
			[MTGCollectionItem]::New([MTGCard]::New('Serum Visions','MM3'),4)
			[MTGCollectionItem]::New([MTGCard]::New('Thought-Knot Seer','OGW'),1)
		))

		# It 'Should export a json file' {
		# 	Mock ConvertTo-Json {}
		# 	Export-Collection -Collection $testCollection -Path $TestCollectionFilePath
		# 	Assert-MockCalled ConvertTo-Json -Exactly 1 -Scope It
		# 	Remove-Item $TestCollectionFilePath -Force
		# }
		It 'Should overwrite an existing file if -Force parameter is specified' {
			New-Item $TestCollectionFilePath
			{ Export-Collection -Collection $testCollection -Path $TestCollectionFilePath -Force } | Should Not Throw
			Remove-Item $TestCollectionFilePath -Force
		}

		# It 'Should export a correctly formated json file' {
		# 	Export-Collection -Collection $testCollection -Path $TestCollectionFilePath
		# 	Get-Content -Path $TestCollectionFilePath | Should Be $TestCollectionFile
		# 	Remove-Item $TestCollectionFilePath -Force
		# }
		# It should export a correctly formated json file
		It 'Should evaluate the output file using get-outputpath cmdlet' {
			Mock Get-OutputPath {
				return $TestCollectionFilePath
			}
			Export-Collection -Collection $testCollection -Path $TestCollectionFilePath
			Assert-MockCalled Get-OutputPath -Exactly 1 -Scope It
			Remove-Item $TestCollectionFilePath -Force
		}

	}
}
