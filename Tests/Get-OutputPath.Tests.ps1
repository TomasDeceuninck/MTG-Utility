. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	
	Describe "Get-OutputPath" {
		$TestLocation = 'TestDrive:\'
		$TestPath = 'TestDrive:\TestFolder\'
		$TestFileName = 'Get-OutputPathTest'
		$TestFileExtension = '.txt'

		# If given path is a file
		# It should alway change the file extension to the default file extension
		# It should return the path of the file if it does not exist
		# It should return the path of the file if it exists and overwrite is forced
		# If the file exists and overwrite is not foced
		# It should return the path of a default file if it does not exist
		# It should return the path of a default file if it exists and overwirte is forced
		# It should throw an error if a default file exists and overwrite is not forced

		# If given path is a folder
		# It should return the path of a default file in the given folder if it does not exist
		# It should return the path of a default file in the given folder if it exists and overwirte is forced
		# It should throw an error if a default file in the given folder exists and overwrite is not forced

		# If the given path is neither an erro should be thrown
	}
}