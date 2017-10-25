function Get-WishlistForSet {
	<#
		.SYNOPSIS
			Get all cards from wishlist that where printed in selected set
		.DESCRIPTION
			Long description
		.EXAMPLE
			PS C:\> <example usage>
			Explanation of what the example does
		.INPUTS
			Inputs (if any)
		.OUTPUTS
			Output (if any)
		.NOTES
			General notes
	#>
	[CmdletBinding()]
	param (
		[Parameter(
			Mandatory = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String[]] $WishList,
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
		$Global:MTGDB | Where-Object {$_.Name -in $WishList} | Where-Object {$Set -in $_.printings}
	}
	end {
	}
}
