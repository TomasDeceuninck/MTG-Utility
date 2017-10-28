function Import-Collection {
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
		[ValidateScript({Test-Path $_})]
		[System.String] $Path,
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $Name
	)
	begin {
		Initialize-MTGDB
	}
	process {
		$collection = [MTGCollection]::New($Name,[System.Version]$SETTINGS.Files.Collection.CurrentVersion)
		Get-Content -Path $Path | ForEach-Object {
			if($_ -match [regex]$SETTINGS.Files.Collection.Pattern){
				$Amount = $Matches[1]
				$Name = $Matches[3].Trim()
				$Set = $Matches[5]
				if($Name){
					if($Global:MTGDB | Where-Object {$_.Name -like $Name}){
						if($Set){
							if($Global:MTGDB | Where-Object {$_.Name -like $Name} | Where-Object {$Set -in $_.printings}){
								if($Amount){
									$collection.Add([MTGCard]::New($Name,$Set),$Amount)
								} else {
									$collection.Add([MTGCard]::New($Name,$Set),1)
								}
							} else {
								throw ('{0} was never printed in {1}' -f $Name,$Set)
							}
						} else {
							throw ('A Set is required for a card. "{0}"' -f $_)
						}
					} else {
						throw ('{0} does not exist in MTGDB' -f $Name)
					}
				} else {
					throw ('A Name is required for a card. "{0}"' -f $_)
				}
			} else {
				throw 'Not all lines in wishlist match the required pattern.'
			}
		}
		$collection
	}
	end {
	}
}