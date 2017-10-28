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
		Get-Content -Path $Path | ForEach-Object {
			if($_ -match [regex]$SETTINGS.Files.Wishlist.Pattern){
				$Amount = $Matches[1]
				$Name = $Matches[3].Trim()
				$Set = $Matches[5]
				if($Name){
					if($Global:MTGDB | Where-Object {$_.Name -like $Name}){
						if($Set){
							if($Global:MTGDB | Where-Object {$_.Name -like $Name} | Where-Object {$Set -in $_.printings}){
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
								[MTGWishlistItem]::New($Name,$Amount)
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
	}
	end {
	}
}
