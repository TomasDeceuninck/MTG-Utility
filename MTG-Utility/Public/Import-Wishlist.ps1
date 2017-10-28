function Import-Wishlist {
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
		# [ValidateScript({Get-Content -Path $_ | ForEach-Object{$_ -match [regex]$SETTINGS.Files.Wishlist.Pattern}})]
		[System.String] $Path
	)
	begin {
		Initialize-MTGDB
	}
	process {
		$import = Get-Content -Path $Path
		# Progress reporting
		$progressTotal = $import.Count
		$progressCurrent = 0
		Write-Progress -Activity 'Importing Wishlist' -Status 'Processing' -PercentComplete ([Math]::Round(($progressCurrent/$progressTotal)*100))
		$import | ForEach-Object {
			Write-Progress -Activity 'Importing Wishlist' -Status ('Processing ({0} of {1})' -f ++$progressCurrent,$progressTotal) -PercentComplete ([Math]::Round(($progressCurrent/$progressTotal)*100)) -CurrentOperation ('{0}' -f $_)
			if($_ -match [regex]$SETTINGS.Files.Wishlist.Pattern){
				$Amount = $Matches[1]
				$Name = $Matches[3].Trim()
				$Set = $Matches[5]
				if($Name){
					$mtgDBWithName = $Global:MTGDB | Where-Object {$_.Name -like $Name}
					if($mtgDBWithName){
						if($Set){
							if($mtgDBWithName | Where-Object {$Set -in $_.printings}){
								if($Amount){
									[MTGWishlistItem]::New($Name,$Amount,$Set)
								} else {
									[MTGWishlistItem]::New($Name,$Set)
								}
							} else {
								throw ('{0} was never printed in {1}' -f $Name,$Set)
							}
						} else {
							if($Amount){
								[MTGWishlistItem]::New($Name,$Amount)
							} else {
								[MTGWishlistItem]::New($Name)
							}
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
		Write-Progress -Activity 'Importing Wishlist' -Status 'Completed' -Completed
	}
	end {
	}
}
