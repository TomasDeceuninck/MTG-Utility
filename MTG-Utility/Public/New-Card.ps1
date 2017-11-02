function New-Card {
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
		[ValidateNotNullOrEmpty()]
		[System.String] $Name,
		[Parameter(
			Mandatory = $false
		)]
		[ValidateNotNullOrEmpty()]
		[System.String] $Set
	)
	begin {
		Initialize-MTGDB
	}
	process {
		$mtgDBCardInfo = $Global:MTGDB | Where-Object {$_.Name -eq $Name}
		if ($mtgDBCardInfo) {
			if ($Set) {
				if ($mtgDBCardInfo | Where-Object {$Set -in $_.printings}) {
					$card = [MTGCard]::New($Name, $Set)
				} else {
					throw ('{0} was never printed in {1}' -f $Name, $Set)
				}
			} else {
				$card = [MTGCard]::New($Name)
			}
			$card.Info = $mtgDBCardInfo
			Initialize-Card -Card $card
		} else {
			throw ('{0} does not exist in MTGDB' -f $Name)
		}
	}
	end {}
}
