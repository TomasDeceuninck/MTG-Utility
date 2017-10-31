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
		[MTGCollection] $Collection
	)
	begin {
		$DEFAULTLOCATION = '.'
		$DEFAULTFILEBASENAME = 'Collection'
		$DEFAULTEXTENSION = '.json'
	}
	process {
		$outputPath = Get-OutputPath -Path $Path -DefaultLocation $DEFAULTLOCATION -DefaultBaseName $DEFAULTFILEBASENAME -DefaultExtension $DEFAULTEXTENSION
		if ($outputPath){
			$Collection | ConvertTo-Json | Out-File $outputPath | Out-Null
			Write-Information -MessageData ('Exported Collection to {0}' -f $outputPath)
		} else {
			Write-Error 'Could not export Collection'
		}
	}
	end {
	}
}