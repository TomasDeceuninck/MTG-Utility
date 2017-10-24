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
		# Specifies a path to one or more locations.
		[Parameter(
			Mandatory = $true,
			Position = 0,
			ParameterSetName = "ParameterSetName",
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = "Path to one or more locations."
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$WishList
	)
	begin {
	}
	process {
	}
	end {
	}
}
