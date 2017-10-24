. $PSScriptRoot\_InitializeTestEnvironment.ps1

InModuleScope MTG-Utility {
	$testJson = @"
{
	"Atinlay Igpay": {
		"layout": "normal",
		"name": "Atinlay Igpay",
		"manaCost": "{5}{W}",
		"cmc": 6,
		"colors": [
		"White"
		],
		"type": "Eaturecray — Igpay",
		"types": [
		"Eaturecray"
		],
		"subtypes": [
		"Igpay"
		],
		"text": "Oubleday ikestray\nEneverwhay Atinlay Igpay's ontrollercay eaksspay ay onnay-Igpay-Atinlay ordway, acrificesay Atinlay Igpay.",
		"power": "3",
		"toughness": "3",
		"imageName": "atinlay igpay",
		"printings": [
		"UNH"
		],
		"legalities": [
		{
			"format": "Un-Sets",
			"legality": "Legal"
		}
		],
		"colorIdentity": [
		"W"
		]
	},
	"AWOL": {
		"layout": "normal",
		"name": "AWOL",
		"manaCost": "{2}{W}",
		"cmc": 3,
		"colors": [
		"White"
		],
		"type": "Instant",
		"types": [
		"Instant"
		],
		"text": "Remove target attacking creature from the game. Then remove it from the removed-from-game zone and put it into the absolutely-removed-from-the-freaking-game-forever zone.",
		"imageName": "awol",
		"printings": [
		"UNH"
		],
		"legalities": [
		{
			"format": "Un-Sets",
			"legality": "Legal"
		}
		],
		"colorIdentity": [
		"W"
		]
	}
}
"@
	Describe "Initialize-MTGDB" {

		Mock Get-Content -Verifiable -ParameterFilter {$Path -eq (Join-Path $moduleRoot $SETTINGS.Resources.MTGJson.Path)} {
			Write-Output $testJson
		}

		It "Gets the content of MTGJson" {
			{ Initialize-MTGDB } | Should Not Throw
			Assert-MockCalled -CommandName Get-Content -Exactly -Times 1 -Scope It
		}

		It "Creates a MTGDB global variable" {
			try {
				Remove-Variable -Name MTGDB -Scope Global -ErrorAction SilentlyContinue
			} catch [System.Management.Automation.ItemNotFoundException] {
				# This is good, it should not exist
			}
			$global:MTGDB | Should Throw
			Initialize-MTGDB
			$global:MTGDB | Should BeOfType System.Management.Automation.PSCustomObject
		}

		Context "Created variable" {
			BeforeAll {
				Initialize-MTGDB
			}

			It "Splits up the MTGJson in list of cards" {
				$global:MTGDB
			}
		}
		
	}
}
