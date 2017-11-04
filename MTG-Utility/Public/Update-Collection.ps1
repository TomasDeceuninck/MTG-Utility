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
		if ($Amount) {
			$add = $Amount
		} else {
			cls
			Write-Host ''
			Write-Host (" Collection:`t$Collection")
			Write-Host (" Card:`t`t$Card")
			Write-Host ' --------------------------------------------'
			Write-Host ''
			$outputTemplate = " {0}`t{1}"
			$collectionItems = $Collection.Get($Card.Name)
			$notCurrentSet = $collectionItems | Where-Object { $_.Card.Set -ne $Card.Set }
			$currentSet = $collectionItems | Where-Object { $_.Card.Set -eq $Card.Set }
			if ($notCurrentSet) {
				$notCurrentSet | ForEach-Object {
					Write-Host ($outputTemplate -f $_.Amount, $_.Card) -ForegroundColor Gray
				}
			}
			if ($currentSet) {
				$currentSet | ForEach-Object {
					Write-Host ($outputTemplate -f $_.Amount, $_.Card) -ForegroundColor Yellow
				}
			} else {
				Write-Host ($outputTemplate -f 0, $Card) -ForegroundColor Red
			}
			Write-Host ''
			$add = Read-Host -Prompt ('Add X copies (0 is default): ')
		}
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
