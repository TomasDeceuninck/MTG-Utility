function Get-OutputPath {
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
		[System.String] $DefaultLocation,
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $DefaultBaseName,
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $DefaultExtension
	)
	begin {
		$DEFAULTFILENAME = ($DefaultBaseName + $DefaultExtension)
	}
	process {
		$targetPath = $null
		if (Test-Path $Path) {
			# The Path exists
			if (Test-Path -Path $Path -PathType Container) {
				# The path is a folder
				$targetPath = Join-Path $Path $DEFAULTFILENAME
				if(Test-Path $targetPath){
					if ($PSCmdlet.ShouldProcess($Path,'Overwrite')){
						$targetPath = $Path
					} else {
						Write-Error ('Could not write {0} because it already exists' -f $targetPath)
						$targetPath = $null
					}
				}
			} else {
				# The path is a file
				#$leaf = Split-Path -Path $Path -Leaf
				$item = (Get-Item $Path)
				$fileBaseName = $item.BaseName
				$fileExtension = $item.Name.Substring($fileBaseName.Length)
				if ($fileExtension -ne $DefaultExtension) {
					Write-Warning -Message ('{0} is not a correct extension for this export. {1} will be used.' -f $fileExtension, $DefaultExtension)
					$targetPath = Join-Path (Split-Path $Path) ($fileBaseName + $DefaultExtension)
				}
				if ($PSCmdlet.ShouldProcess($Path,'Overwrite')){
					$targetPath = $Path
				} else {
					$directory = Split-Path $Path
					Test-Path ($directory){
						$targetPath = Join-Path $directory $DEFAULTFILENAME
					} else {
						$targetPath = Join-Path $DefaultLocation $DEFAULTFILENAME
					}
				}
			}
		} elseif (Test-Path -Path (Split-Path -Path $Path)) {
			# The folder it is pointing to exists
			$fileName = Split-Path -Path $Path -Leaf
			$fileBaseName = $fileName.substring(0,$fileName.LastIndexOf('.'))
			$fileExtension = $fileName.substring($fileName.LastIndexOf('.'))
			if($fileExtension -eq $DefaultExtension){
				$targetPath = $Path
			} else {
				Write-Warning -Message ('{0} is not a correct extension for this export. {1} will be used.' -f $fileExtension, $DefaultExtension)
				$targetPath = Join-Path (Split-Path -Path $Path) ($fileBaseName + $DefaultExtension)
				if(Test-Path $targetPath){
					if ($PSCmdlet.ShouldProcess($targetPath,'Overwrite')){
						#It can be over writen
					} else {
						if($fileBaseName -eq $DefaultBaseName){
							Write-Error ('Could not write {0} because it already exists' -f $targetPath)
							$targetPath = $null
						} else {
							$targetPath = $targetPath = Join-Path (Split-Path -Path $Path) $DEFAULTFILENAME
							if (Test-Path $targetPath) {
								if ($PSCmdlet.ShouldProcess($targetPath,'Overwrite')){
									#It can be over writen
								} else {
									Write-Error ('Could not write {0} because it already exists' -f $targetPath)
									$targetPath = $null
								}
							} else {
								# It does not exist and $targetPath is oke
							}
						}
					}
				} else {
					# It does not exist and $targetPath is oke
				}
			}
		} else {
			Write-Error 'Incorrect Path'
		}
		Write-Output $targetPath
	}
	end {}
}