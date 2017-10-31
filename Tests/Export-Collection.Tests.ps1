. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Export-Collection" {
		# It should export a json file
		# It should export a correctly formated json file
		# It should evaluate the output file using get-outputpath cmdlet
	}
}