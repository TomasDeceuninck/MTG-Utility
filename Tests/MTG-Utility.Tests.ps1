. $PSScriptRoot\_InitializeTestEnvironment.ps1

Describe "MTG-Utility" {
	Context "All required tests are present" {
		It "Includes a test for each public PowerShell function in the module" {
			Get-ChildItem -Path $publicFunctions -Filter "*.ps1" -Recurse | Where-Object -FilterScript {$_.Name -notlike '*.Tests.ps1'} | % {
				$expectedTestFile = Join-Path $projectRoot "Tests\$($_.BaseName).Tests.ps1"
				$expectedTestFile | Should Exist
			}
		}
		It "Includes a test for each private PowerShell function in the module" {
			Get-ChildItem -Path $privateFunctions -Filter "*.ps1" -Exclude '_Classes.ps1' -Recurse | Where-Object -FilterScript {$_.Name -notlike '*.Tests.ps1'} | % {
				$expectedTestFile = Join-Path $projectRoot "Tests\$($_.BaseName).Tests.ps1"
				$expectedTestFile | Should Exist
			}
		}
	}

	Context "Style checking" {

		$files = @(
			Get-ChildItem $here -Include *.ps1, *.psm1
			Get-ChildItem $publicFunctions -Include *.ps1, *.psm1 -Recurse
			Get-ChildItem $privateFunctions -Include *.ps1, *.psm1 -Recurse
		)

		It 'Source files contain no trailing whitespace' {
			$badLines = @(
				foreach ($file in $files) {
					$lines = [System.IO.File]::ReadAllLines($file.FullName)
					$lineCount = $lines.Count

					for ($i = 0; $i -lt $lineCount; $i++) {
						if ($lines[$i] -match '\s+$') {
							'File: {0}, Line: {1}' -f $file.FullName, ($i + 1)
						}
					}
				}
			)

			if ($badLines.Count -gt 0) {
				throw "The following $($badLines.Count) lines contain trailing whitespace: `r`n`r`n$($badLines -join "`r`n")"
			}
		}

		It 'Source files all end with a newline' {
			$badFiles = @(
				foreach ($file in $files) {
					$string = [System.IO.File]::ReadAllText($file.FullName)
					if ($string.Length -gt 0 -and $string[-1] -ne "`n") {
						$file.FullName
					}
				}
			)

			if ($badFiles.Count -gt 0) {
				throw "The following files do not end with a newline: `r`n`r`n$($badFiles -join "`r`n")"
			}
		}
	}
}
