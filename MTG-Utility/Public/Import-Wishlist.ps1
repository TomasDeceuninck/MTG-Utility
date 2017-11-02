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
		[ValidateScript( {Test-Path $_})]
		[System.String] $Path
	)
	begin {
		Initialize-MTGDB
	}
	process {
		$import = Get-Content -Path $Path
		# Progress reporting
		$progressTotal = $import.Count
		$progressStartTime = Get-Date
		$progressCurrent = 0
		Write-Progress -Activity 'Importing Wishlist' -Status 'Processing' -PercentComplete 0
		$import | ForEach-Object {
			Write-Progress -Activity 'Importing Wishlist' -Status ('Processing ({0} of {1})' -f ++$progressCurrent, $progressTotal) -PercentComplete ([Math]::Round(($progressCurrent / $progressTotal) * 100)) -CurrentOperation ('{0}' -f $_) -SecondsRemaining (((((Get-Date) - $progressStartTime).TotalSeconds) / $progressCurrent) * ($progressTotal - $progressCurrent))
			if ($_ -match [regex]$SETTINGS.Files.Wishlist.Pattern) {
				$Amount = $Matches[1]
				$Name = $Matches[3].Trim()
				$Set = $Matches[5]
				if ($Name) {
					if ($Set) {
						$card = New-Card -Name $Name -Set $Set
					} else {
						$card = New-Card -Name $Name
					}
					if ($Amount) {
						[MTGWishlistItem]::New($card, $Amount)
					} else {
						[MTGWishlistItem]::New($card)
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
