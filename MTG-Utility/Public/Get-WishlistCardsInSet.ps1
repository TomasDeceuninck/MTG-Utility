function Get-WishlistCardsInSet {
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
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[ValidateNotNullOrEmpty()]
		[MTGWishlistItem[]] $Wishlist,
		[Parameter(
			Mandatory = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]	$Set
	)
	begin {
		Initialize-MTGDB
	}
	process {
		$wishlistCardNamesForSet = $Wishlist | Where-Object {(-not $_.Card.Set) -or ($_.Card.Set -eq $Set)} | Select-Object -ExpandProperty Card | Select-Object -ExpandProperty Name
		$Global:MTGDB | Where-Object {$_.Name -in $wishlistCardNamesForSet} | Where-Object {$Set -in $_.printings} | ForEach-Object {
			New-Card -Name $_.Name -Set $Set
		}
	}
	end {
	}
}
