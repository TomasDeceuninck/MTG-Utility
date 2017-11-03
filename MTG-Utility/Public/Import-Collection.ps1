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
		[ValidateScript( {Test-Path $_})]
		[System.String] $Path
	)
	begin {
		Initialize-MTGDB
	}
	process {
		Write-Progress -Activity 'Importing Collection' -Status 'Processing' -PercentComplete 0
		try {
			$import = Get-Content -Path $Path | ConvertFrom-Json
		} catch {
			throw 'Something went wrong importing your collection file'
		}
		if ($import.PSObject.Properties.Name -contains 'Version') {
			if ([System.Version]$import.version -lt [System.Version]$SETTINGS.Files.Collection.MinimumRequiredVersion) {
				throw ('The selected collection has version {0} which is no longer supported (Minimum Required Version = {1}' -f [System.Version]$import.version, [System.Version]$SETTINGS.Files.Collection.MinimumRequiredVersion)
			} else {
				if ($import.PSObject.Properties.Name -contains 'Name') {
					$collection = [MTGCollection]::New($import.Name)
					if ($import.PSObject.Properties.Name -contains 'Items') {
						$progressTotal = $import.Items.Count
						$progressStartTime = Get-Date
						$progressCurrent = 0
						foreach ($card in $import.Items) {
							Write-Progress -Activity 'Importing Collection' -Status ('Processing ({0} of {1})' -f ++$progressCurrent, $progressTotal) -PercentComplete ([Math]::Round(($progressCurrent / $progressTotal) * 100)) -CurrentOperation ('{0}' -f $_) -SecondsRemaining (((((Get-Date) - $progressStartTime).TotalSeconds) / $progressCurrent) * ($progressTotal - $progressCurrent))
							if (($card.PSObject.Properties.Name -contains 'Card') -and
								($card.PSObject.Properties.Name -contains 'Amount')) {
								if ($card.Card -match [regex]$SETTINGS.Files.Collection.Pattern) {
									try {
										$Name = [System.String]$Matches[1]
										$Set = [System.String]$Matches[3]
										$Amount = [System.Int32]$card.Amount
									} catch {
										throw 'Something went wrong casting card parameters'
									}
									$collection.Add((New-Card -Name $Name -Set $Set), $Amount)
								}
							}
						}
					}
				} else {
					throw 'Name propertie does not exist for selected collection'
				}
			}
		} else {
			throw 'Version propertie does not exist for selected collection'
		}
		Write-Progress -Activity 'Importing Collection' -Status 'Completed' -Completed
		$collection
	}
	end {
	}
}
