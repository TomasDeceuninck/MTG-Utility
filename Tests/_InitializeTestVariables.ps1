# Test variables
$TestJson = @"
{
	"Lightning Bolt": {
		"layout": "normal",
		"name": "Lightning Bolt",
		"manaCost": "{R}",
		"cmc": 1,
		"colors": [
			"Red"
		],
		"type": "Instant",
		"types": [
			"Instant"
		],
		"text": "Lightning Bolt deals 3 damage to target creature or player.",
		"imageName": "lightning bolt",
		"printings": [
			"LEA",
			"LEB",
			"2ED",
			"CED",
			"CEI",
			"3ED",
			"4ED",
			"pJGP",
			"ATH",
			"BTD",
			"pMPR",
			"MED",
			"M10",
			"M11",
			"PD2",
			"MM2",
			"E01"
		],
		"legalities": [
			{
			"format": "Commander",
			"legality": "Legal"
			},
			{
			"format": "Legacy",
			"legality": "Legal"
			},
			{
			"format": "Modern",
			"legality": "Legal"
			},
			{
			"format": "Vintage",
			"legality": "Legal"
			}
		],
		"colorIdentity": [
			"R"
		]
	},
	"Serum Visions": {
		"layout": "normal",
		"name": "Serum Visions",
		"manaCost": "{U}",
		"cmc": 1,
		"colors": [
			"Blue"
		],
		"type": "Sorcery",
		"types": [
			"Sorcery"
		],
		"text": "Draw a card. Scry 2.",
		"imageName": "serum visions",
		"printings": [
			"pARL",
			"pFNM",
			"5DN",
			"CN2",
			"MM3"
		],
		"legalities": [
			{
			"format": "Commander",
			"legality": "Legal"
			},
			{
			"format": "Legacy",
			"legality": "Legal"
			},
			{
			"format": "Mirrodin Block",
			"legality": "Legal"
			},
			{
			"format": "Modern",
			"legality": "Legal"
			},
			{
			"format": "Vintage",
			"legality": "Legal"
			}
		],
		"colorIdentity": [
			"U"
		]
	},
	"Liliana of the Veil": {
		"layout": "normal",
		"name": "Liliana of the Veil",
		"manaCost": "{1}{B}{B}",
		"cmc": 3,
		"colors": [
			"Black"
		],
		"type": "Legendary Planeswalker — Liliana",
		"supertypes": [
			"Legendary"
		],
		"types": [
			"Planeswalker"
		],
		"subtypes": [
			"Liliana"
		],
		"text": "+1: Each player discards a card.\n−2: Target player sacrifices a creature.\n−6: Separate all permanents target player controls into two piles. That player sacrifices all permanents in the pile of his or her choice.",
		"loyalty": 3,
		"imageName": "liliana of the veil",
		"rulings": [
			{
			"date": "2017-03-14",
			"text": "When Liliana's first ability resolves, first the player whose turn it is chooses a card to discard, then each other player in turn order chooses a card to discard, then those cards are discarded simultaneously. No one sees what the other players are discarding before deciding which card to discard."
			},
			{
			"date": "2017-03-14",
			"text": "The player targeted by Liliana's second ability chooses which creature to sacrifice when the ability resolves. This ability doesn't target any creature."
			},
			{
			"date": "2017-03-14",
			"text": "When Liliana's third ability resolves, you put each permanent the player controls into one of the two piles. For example, you could put a creature into one pile and an Aura enchanting that creature into the other pile."
			},
			{
			"date": "2017-03-14",
			"text": "A pile can be empty. If the player chooses an empty pile, no permanents will be sacrificed."
			}
		],
		"printings": [
			"ISD",
			"pWCQ",
			"MM3"
		],
		"legalities": [
			{
			"format": "Commander",
			"legality": "Legal"
			},
			{
			"format": "Innistrad Block",
			"legality": "Legal"
			},
			{
			"format": "Legacy",
			"legality": "Legal"
			},
			{
			"format": "Modern",
			"legality": "Legal"
			},
			{
			"format": "Vintage",
			"legality": "Legal"
			}
		],
		"colorIdentity": [
			"B"
		]
	},
	"Snapcaster Mage": {
		"layout": "normal",
		"name": "Snapcaster Mage",
		"manaCost": "{1}{U}",
		"cmc": 2,
		"colors": [
			"Blue"
		],
		"type": "Creature — Human Wizard",
		"types": [
			"Creature"
		],
		"subtypes": [
			"Human",
			"Wizard"
		],
		"text": "Flash\nWhen Snapcaster Mage enters the battlefield, target instant or sorcery card in your graveyard gains flashback until end of turn. The flashback cost is equal to its mana cost. (You may cast that card from your graveyard for its flashback cost. Then exile it.)",
		"power": "2",
		"toughness": "1",
		"imageName": "snapcaster mage",
		"rulings": [
			{
			"date": "2017-03-14",
			"text": "If you cast an instant or sorcery with {X} in its mana cost this way, you still choose the value of X as part of casting the spell and pay that cost."
			},
			{
			"date": "2017-03-14",
			"text": "If an instant or sorcery card in your graveyard already has flashback, you may use either flashback ability to cast it from your graveyard."
			},
			{
			"date": "2017-03-14",
			"text": "You may pay any optional additional costs the spell has, such as conspire costs. You must pay any mandatory additional costs the spell has, such as that of Bone Splinters."
			},
			{
			"date": "2017-04-18",
			"text": "For split cards, the flashback cost you pay is determined by the half you cast"
			}
		],
		"printings": [
			"ISD",
			"pWCQ",
			"MM3"
		],
		"legalities": [
			{
			"format": "Commander",
			"legality": "Legal"
			},
			{
			"format": "Innistrad Block",
			"legality": "Legal"
			},
			{
			"format": "Legacy",
			"legality": "Legal"
			},
			{
			"format": "Modern",
			"legality": "Legal"
			},
			{
			"format": "Vintage",
			"legality": "Legal"
			}
		],
		"colorIdentity": [
			"U"
		]
	},
	"Abrupt Decay": {
		"layout": "normal",
		"name": "Abrupt Decay",
		"manaCost": "{B}{G}",
		"cmc": 2,
		"colors": [
			"Black",
			"Green"
		],
		"type": "Instant",
		"types": [
			"Instant"
		],
		"text": "Abrupt Decay can't be countered by spells or abilities.\nDestroy target nonland permanent with converted mana cost 3 or less.",
		"imageName": "abrupt decay",
		"rulings": [
			{
			"date": "2017-03-14",
			"text": "The converted mana cost of a creature token is 0, unless that token is a copy of another creature, in which case it copies that creature's mana cost."
			},
			{
			"date": "2017-03-14",
			"text": "If a permanent has {X} in its mana cost, X is considered to be 0."
			}
		],
		"printings": [
			"RTR",
			"MM3"
		],
		"legalities": [
			{
			"format": "Commander",
			"legality": "Legal"
			},
			{
			"format": "Legacy",
			"legality": "Legal"
			},
			{
			"format": "Modern",
			"legality": "Legal"
			},
			{
			"format": "Return to Ravnica Block",
			"legality": "Legal"
			},
			{
			"format": "Vintage",
			"legality": "Legal"
			}
		],
		"colorIdentity": [
			"B",
			"G"
		]
	},
	"Thought-Knot Seer": {
		"layout": "normal",
		"name": "Thought-Knot Seer",
		"manaCost": "{3}{C}",
		"cmc": 4,
		"type": "Creature — Eldrazi",
		"types": [
		"Creature"
		],
		"subtypes": [
		"Eldrazi"
		],
		"text": "({C} represents colorless mana.)\nWhen Thought-Knot Seer enters the battlefield, target opponent reveals his or her hand. You choose a nonland card from it and exile that card.\nWhen Thought-Knot Seer leaves the battlefield, target opponent draws a card.",
		"power": "4",
		"toughness": "4",
		"imageName": "thought-knot seer",
		"printings": [
		"OGW"
		],
		"legalities": [
		{
			"format": "Battle for Zendikar Block",
			"legality": "Legal"
		},
		{
			"format": "Commander",
			"legality": "Legal"
		},
		{
			"format": "Legacy",
			"legality": "Legal"
		},
		{
			"format": "Modern",
			"legality": "Legal"
		},
		{
			"format": "Standard",
			"legality": "Legal"
		},
		{
			"format": "Vintage",
			"legality": "Legal"
		}
		]
	}
}
"@
$TestCardCount = 6
$TestSets = @('LEA', 'LEB', '2ED', 'CED', 'CEI', '3ED', '4ED', 'pJGP', 'ATH', 'BTD', 'pMPR', 'MED', 'M10', 'M11', 'PD2', 'MM2', 'E01', 'pARL', 'pFNM', '5DN', 'CN2', 'MM3', 'ISD', 'pWCQ', 'RTR', 'OGW')
$TestCardNames = @(
	'Lightning Bolt'
	'Liliana of the Veil'
	'Serum Visions'
	'Thought-Knot Seer'
)
$TestWishlistPath = 'C:\RAZY\PATH'
$TestWishlist = @(
	'1 Lightning Bolt [pMPR]'
	'2  Liliana of the Veil '
	'Serum Visions  [MM3]'
	' Thought-Knot Seer'
)
$TestWishlist_BadFormat = @(
	'1	Lightning Bolt [pMPR]'
	'Liliana of the Veil 2'
	'[MM3] Serum Visions  '
	' Thought-Knot Seer'
)
$TestWishlist_FakePrintings = @(
	'1	Lightning Bolt [M15]'
	'2  Liliana of the Veil' 
	'Serum Visions  [MM2]'
	' Thought-Knot Seer'
)
$TestWishlist_FakeCards = @(
	'1	Crazy Cool Fake Card, of The masters'
	'2  Liliana of the Veil '
	'Serum Visions  [MM2]'
	' Thought-Knot Seer'
)