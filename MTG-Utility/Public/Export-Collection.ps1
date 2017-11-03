function Export-Collection {
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
		SupportsShouldProcess = $true,
		ConfirmImpact = "High"
	)]
	param (
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $Path,
		[Parameter(
			Mandatory = $true
		)]
		[MTGCollection] $Collection,
		[Parameter(
			Mandatory = $false
		)]
		[switch] $Force
	)
	begin {
		$DEFAULTFILEBASENAME = 'Collection'
		$DEFAULTEXTENSION = '.mtgc'
	}
	process {
		$outputPath = Get-OutputPath -Path $Path -DefaultBaseName $DEFAULTFILEBASENAME -DefaultExtension $DEFAULTEXTENSION -Confirm:(!$Force)
		if ($outputPath) {
			New-Object PSObject -Property @{
				Version = ([System.Version]$SETTINGS.Files.Collection.CurrentVersion).ToString()
				Name    = $Collection.Name
				Items   = ($Collection.Items | Select-Object * | Sort-Object Name)
			} | ConvertTo-Json | Out-File -Encoding unicode $outputPath -Force | Out-Null
			Write-Information -MessageData ('Exported Collection to {0}' -f $outputPath)
		} else {
			Write-Error 'Could not export Collection'
		}
	}
	end {
	}
}
