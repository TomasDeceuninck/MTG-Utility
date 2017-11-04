function Initialize-Card {
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
		[MTGCard] $Card,
		[Parameter(
			Mandatory = $false
		)]
		[ValidateNotNullOrEmpty()]
		[switch] $ReInitialize
	)
	begin {}
	process {
		# Add Info
		if (!$Card.Info -or $ReInitialize) {
			Initialize-MTGDB
			$Card.Info = $Global:MTGDB | Where-Object { $_.Name -eq $Card.Name}
		}
		# Add ColorID
		if (!$Card.ColorID -or $ReInitialize) {
			if ($Card.Info.Colors.Count -gt 1) {
				$Card.ColorID = [MTGColorID]::Multicolor
			} elseif ($Card.Info.Colors.Count -eq 1)	{
				$Card.ColorID = [MTGColorID]::($Card.Info.Colors | Select-Object -First 1)
			} elseif ($Card.Info.Type -like "*Land*") {
				$Card.ColorID = [MTGColorID]::Land
			} else {
				$Card.ColorID = [MTGColorID]::Colorless
			}
		}
		$Card
	}
	end {}
}
