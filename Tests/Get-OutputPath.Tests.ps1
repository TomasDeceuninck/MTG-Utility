. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	. $PSScriptRoot\_InitializeTestVariables.ps1
	$WarningPreference = 'SilentlyContinue'

	Describe "Get-OutputPath" {
		$testLocation = 'TestDrive:\'
		$testPath = 'TestDrive:\TestFolder\'
		$testDefaultFileExtension = '.test'
		$testDefaultFileBaseName = 'DefaultBaseName'
		$testDefaultPath = $testPath + $testDefaultFileBaseName + $testDefaultFileExtension
		$testNewFileBaseName = 'Get-OutputPathTest'
		$testNewFileExtension = '.txt'
		$testNewPath = $testPath + $testNewFileBaseName + $testNewFileExtension
		$testExistingFileBaseName = 'ExistingFile'
		$testExistingFileExtension = '.tset'
		$testExistingPath = $testPath + $testExistingFileBaseName + $testExistingFileExtension

		New-Item -Path $testPath -ItemType Directory
		New-Item -Path $testExistingPath
		New-Item -Path (Join-Path $testPath ($testExistingFileBaseName + $testDefaultFileExtension))

		Context 'New file' {
			It 'should alway change the file extension to the default file extension' {
				$output = Get-OutputPath -Path $testNewPath -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension
				$output.substring($output.LastIndexOf('.')) | Should Be $testDefaultFileExtension
			}
			It 'should return the path of the file if it does not exist yet' {
				Get-OutputPath -Path $testNewPath -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension `
					| Should Be ( Join-Path $testPath ($testNewFileBaseName + $testDefaultFileExtension) )
			}
		}
		Context 'Existing File' {
			It 'should return the path of the file if it exists and overwrite is forced' {
				Get-OutputPath -Path $testExistingPath -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension -Confirm:$false `
					| Should Be ( Join-Path $testPath ($testExistingFileBaseName + $testDefaultFileExtension) )
			}
			It 'should return the path of a default file if no overwite is permitted and default file does not exist' {
				# Cannot mock Should process
			}
			It 'should throw if no overwrite is permitted and default file exists' {
				# Cannot mock Should process
			}
		}
		Context 'Existing Folder' {
			It 'should return the path of a default file in the given folder if that file does not exist' {
				Get-OutputPath -Path $testPath -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension -Confirm:$false `
					| Should Be $testDefaultPath
			}
			It 'should return the path of a default file in the given folder if that file exists and overwirte is forced' {
				New-Item -Path $testDefaultPath
				Get-OutputPath -Path $testPath -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension -Confirm:$false `
					| Should Be $testDefaultPath
				Remove-Item $testDefaultPath -Force
			}
			It 'should throw an error if a default file in the given folder exists and overwrite is not forced' {
				# Cannot mock Should process
			}
		}
		Context 'Anything Else'	{
			It 'Should throw an error if the input is neither a file nor an existing folder' {
				{ Get-OutputPath -Path (Join-Path $testLocation 'jiberish\CrazyStuff') -DefaultBaseName $testDefaultFileBaseName -DefaultExtension $testDefaultFileExtension } | Should Throw
			}
		}
	}
}
