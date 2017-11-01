function New-Collection {
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
	[CmdletBinding(
		DefaultParameterSetName = 'Cards'
	)]
	param (
		[Parameter(
			Mandatory = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String] $Name,
		[Parameter(
			Mandatory = $false,
			ParameterSetName = 'Cards'
		)]
		[ValidateNotNullOrEmpty()]
		[MTGCard[]] $Cards,
		[Parameter(
			Mandatory = $false,
			ParameterSetName = 'Items'
		)]
		[ValidateNotNullOrEmpty()]
		[MTGCollectionItem[]] $Items
	)
	begin {}
	process {
		if ($Cards) {
			$collection = [MTGCollection]::New($Name)
			$Cards | ForEach-Object { $collection.Add($_) }
		} elseif ($Items) {
			[MTGCollection]::New($Name, $Items)
		}
		if ($Cards) {
			[MTGCollection]::New($Name, $Cards)
		} else {
			[MTGCollection]::New($Name)
		}
	}
	end {}
}
