function Initialize-MTGDB {
	[CmdletBinding()]
	param()
	begin {
	}
	process {
		$global:MTGDB = ((Get-Content (Join-Path $MODULEROOT $SETTINGS.Resources.MTGJson.Path) | ConvertFrom-Json).psobject.Members | Where-Object{
			$_.MemberType -eq 'NoteProperty'
		} | Select-Object -ExpandProperty Value)
	}
	end {
	}
}
