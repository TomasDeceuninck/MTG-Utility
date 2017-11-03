Enum MTGColorID {
	White
	Blue
	Black
	Red
	Green
	Multicolor
	Colorless
	Land
}

Class MTGCard {
	[ValidateNotNullOrEmpty()]
	[System.String] $Name
	[System.String] $Set
	[MTGColorID] $ColorID
	[PSObject[]] $Info

	# Constructor
	MTGCard ([System.String] $Name) {
		$this.Name = $Name
	}
	MTGCard ([System.String] $Name, [System.String] $Set) {
		$this.Name = $Name
		$this.Set = $Set
	}

	[System.Boolean] IsUniquelyIdentifiable() {
		return (![System.String]::IsNullOrEmpty($this.Name) -and ![System.String]::IsNullOrEmpty($this.Set))
	}

	[System.Boolean] IsInitialized() {
		return (![System.String]::IsNullOrEmpty($this.Name) -and ![System.String]::IsNullOrEmpty($this.Info) -and ![System.String]::IsNullOrEmpty($this.ColorID))
	}

	[System.Boolean] Equals($Card) {
		return (($this.Name -like $Card.Name) -and ($this.Set -like $Card.Set))
	}

	[System.String] ToString() {
		if ([System.String]::IsNullOrEmpty($this.Name)) {
			return 'UNKNOWN'
		} else {
			if ([System.String]::IsNullOrEmpty($this.Set)) {
				return $this.Name
			} else {
				return ('{0} [{1}]' -f $this.Name, $this.Set)
			}
		}
	}
}

Class MTGCollectionItem {
	hidden [MTGCard] $_Card = $($this | Add-Member ScriptProperty 'Card' {
			# get
			$this._Card
		} {
			# set
			param ( $Card )
			if ($Card.IsUniquelyIdentifiable()) {
				$this._Card = $Card
			} else {
				throw ('MTGCard {0} is not uniquely identifable' -f $Card)
			}
		}
	)
	[ValidateNotNullOrEmpty()]
	[System.Int32] $Amount

	# Constructor
	MTGCollectionItem ([MTGCard] $Card, [System.Int32] $Amount) {
		$this.Card = $Card
		$this.Amount = $Amount
	}
}

Class MTGCollection {
	[ValidateNotNullOrEmpty()]
	[System.String] $Name
	hidden [System.Collections.ArrayList] $_Items = $($this | Add-Member ScriptProperty 'Items' {
			# get
			[MTGCollectionItem[]]$this._Items
		} {
			# set
			param ( [MTGCollectionItem[]] $arg )
			$this._Items = New-Object System.Collections.ArrayList(, $arg)
		}
	)

	# Constructor
	MTGCollection ([System.String] $Name) {
		$this.Name = $Name
		$this._Items = New-Object System.Collections.ArrayList
	}
	MTGCollection ([System.String] $Name, [MTGCollectionItem[]] $Items) {
		$this.Name = $Name
		$this.Items = $Items
	}

	[MTGCollectionItem] Get([MTGCard] $Card) {
		$found = $this._Items.Where( {$_.Card.Equals($Card)})
		if ($found.Count -gt 1) {
			throw 'Collection contains multiple entries for the same card'
		} else {
			return $found
		}
	}

	[MTGCollectionItem[]] Get([System.String] $Name) {
		return $this._Items.Where( {$_.Card.Name -eq $Name})
	}

	Add([MTGCard] $Card, [System.Int32] $Amount) {
		$existingItem = $this._Items.Where( {$_.Card.Equals($Card)})
		$totalAmmount = $Amount
		foreach ($item in $existingItem) {
			$totalAmmount += $item.Amount
			$this._Items.Remove($item)
		}
		if ($totalAmmount -gt 0) {
			$this._Items.Add([MTGCollectionItem]::New($Card, $totalAmmount))
		}
	}
	Add([MTGCard] $Card) {
		$this.Add($Card, 1)
	}

	Remove([MTGCard] $Card, [System.Int32] $Amount) {
		$existingItem = $this._Items.Where( {$_.Card.Equals($Card)})
		$totalAmmount = - $Amount
		foreach ($item in $existingItem) {
			$totalAmmount += $item.Amount
			$this._Items.Remove($item)
		}
		if ($totalAmmount -gt 0) {
			$this._Items.Add([MTGCollectionItem]::New($Card, $totalAmmount))
		}
	}
	Remove([MTGCard] $Card) {
		$this.Remove($Card, 1)
	}

	RemoveAll([MTGCard] $Card) {
		$existingItem = $this._Items.Where( {$_.Card.Equals($Card)})
		foreach ($item in $existingItem) {
			$this._Items.Remove($item)
		}
	}
	# Remove all does not seem relevant but only dangerous?
	# RemoveAll([System.Boolean] $Confirm) {
	# 	if (!$Confirm) {
	# 		$user = Read-Host -Prompt 'Are you sure you want to remove all cards from this collection? (y/N) '
	# 		$Confirm = ($user -like 'y')
	# 	}
	# 	if ($Confirm) {
	# 		$this._Items = New-Object System.Collections.ArrayList
	# 	}
	# }
	# RemoveAll() {
	# 	$this.RemoveAll($false)
	# }

	[System.Int32] TotalAmountOfCards() {
		$total = 0
		foreach ($item in $this._Items) {
			$total += $item.Amount
		}
		return $total
	}

	[System.String] ToString() {
		return ('{0} [{1}]' -f $this.Name, $this.TotalAmountOfCards())
	}
}

Class MTGWishlistItem {
	[ValidateNotNullOrEmpty()]
	[System.Int32] $Amount
	[ValidateNotNullOrEmpty()]
	[MTGCard] $Card

	# Constructor
	MTGWishlistItem ([MTGCard] $Card) {
		$this.Card = $Card
		$this.Amount = 1
	}
	MTGWishlistItem ([MTGCard] $Card, [System.Int32] $Amount) {
		$this.Card = $Card
		$this.Amount = $Amount
	}
}
