. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Import-Collection" {
		# Mock the exported collection
		$TestCollectionFile | Out-File -FilePath $TestCollectionFilePath
		# Mock the MTGDB and MTGSets
		Mock Initialize-MTGDB {
			$Global:MTGDB = ($TestJson | ConvertFrom-Json).PSObject.Members | Where-Object{$_.MemberType -eq 'NoteProperty'} | Select-Object -ExpandProperty Value
		}

		#ToDo
	}
}
