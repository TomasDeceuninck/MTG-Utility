function Initialize-MTGDB {
	[CmdletBinding()]
	param()
	begin {
	}
	process {
		if (!$Global:MTGDB) {
			Set-Variable -Name MTGDB -Scope Global -Value ((Get-Content (Join-Path $MODULEROOT $SETTINGS.Resources.MTGJson.Path) | ConvertFrom-Json).psobject.Members | Where-Object {
					$_.MemberType -eq 'NoteProperty'
				} | Select-Object -ExpandProperty Value)
		}
		if (!$Global:MTGSets) {
			Set-Variable -Name MTGSets -Scope Global -Value ($Global:MTGDB | ForEach-Object {$_.printings} | Select-Object -Unique)
		}
	}
	end {
	}
}
