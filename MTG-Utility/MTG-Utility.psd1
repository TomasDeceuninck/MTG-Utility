@{
	RootModule        = 'MTG-Utility.psm1'
	ModuleVersion     = '0.1.0.0'
	GUID              = '5fef9356-84ff-4c09-81e7-48b9abb8b7fc'
	Author            = 'Tomas Deceuninck'
	Copyright         = '(c) 2014-17 Tomas Deceuninck. All rights reserved.'
	Description       = 'MTG-Utility provides a PowerShell cmdlets for managing a MTG collection.'
	PowerShellVersion = '5.0'

	FunctionsToExport = '*'
	CmdletsToExport   = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'

	PrivateData       = @{
		PSData = @{
			#Tags       = @()
			#LicenseUri = 'https://..../LICENSE.txt'
			#ProjectUri = 'https://...'
			#IconUri = ''
			#ReleaseNotes = ''
		}
	}
}
