function Initialize-MTGDB {
	[CmdletBinding()]
	param()
	begin {
	}
	process {
		if (!$Global:MTGDB) {
			Write-Progress -Activity 'Initializing MTGDB' -Status 'Processing'
			Set-Variable -Name MTGDB -Scope Global -Value ((Get-Content (Join-Path $MODULEROOT $SETTINGS.Resources.MTGJson.Path) | ConvertFrom-Json).psobject.Members | Where-Object {
					$_.MemberType -eq 'NoteProperty'
				} | Select-Object -ExpandProperty Value)
			Write-Progress -Activity 'Initializing MTGDB' -Completed
		}
		if (!$Global:MTGSets) {
			Write-Progress -Activity 'Initializing MTGSets' -Status 'Processing'
			Set-Variable -Name MTGSets -Scope Global -Value ($Global:MTGDB | ForEach-Object {$_.printings} | Select-Object -Unique)
			Write-Progress -Activity 'Initializing MTGSets' -Completed
		}
	}
	end {
	}
}
