# Input
# list of cards (could be all cards)
# for each card collection is checked
# text indicates if the card is already in the collection for that set and how many times
# if the card is in the collection but not for that set this is also indicated and how many times for which sets.
# user has the option to add x amount of cards to his collection
function Update-Collection {
	<#
		.SYNOPSIS
			#ToDo
		.DESCRIPTION
			#ToDo
		.EXAMPLE
			#ToDo
		.INPUTS
			#ToDo
		.OUTPUTS
			#ToDo
		.NOTES
			#ToDo
	#>
	[CmdletBinding()]
	param (
		[Parameter(
			Mandatory = $true
		)]
		[MTGCollection] $Collection,
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateScript( {$_.IsUniquelyIdentifiable()})]
		[MTGCard] $Card,
		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[MTGCard] $Amount,
		[Parameter(
			Mandatory = $false
		)]
		[System.Diagnostics.Switch] $PassThru
	)
	begin {}
	process {
		$collectionItem = $Collection.Get($Card)
		if ($collectionItem) {
			Write-Host $Card -ForegroundColor Yellow
			if ($collectionItem.Amount -eq 1) {
				$current = 'You have 1 copy.'
			} else {
				$current = ('You have {0} copies.' -f $collectionItem.Amount)
			}
		} else {
			Write-Host $Card -ForegroundColor Gray
			$current = 'You have no copies.'
		}
		$add = Read-Host -Prompt ('{0} Add (0 is default): ' -f $current)
		try {
			$add = [System.Int32]$add
		} catch [System.Management.Automation.PSInvalidCastException] {
			$add = 0
		}
		$Collection.Add($Card, $add)
		if ($PassThru) {
			$Collection
		}
	}
	end {}
}
