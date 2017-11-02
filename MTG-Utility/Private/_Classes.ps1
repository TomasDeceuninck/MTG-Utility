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
	hidden [System.Collections.ArrayList] $Items = $($this | Add-Member ScriptProperty 'Cards' {
			# get
			[MTGCollectionItem[]]$this.Items
		} {
			# set
			param ( $arg )
			$this.Items = New-Object System.Collections.ArrayList(, $arg)
		}
	)

	# Constructor
	MTGCollection ([System.String] $Name) {
		$this.Name = $Name
		$this.Items = New-Object System.Collections.ArrayList
	}
	MTGCollection ([System.String] $Name, [MTGCollectionItem[]] $Cards) {
		$this.Name = $Name
		$this.Cards = $Cards
	}

	[MTGCollectionItem[]] Get([MTGCard] $Card) {
		return $this.Items.Where( {$_.Card.Equals($Card)})
	}

	Add([MTGCard] $Card, [System.Int32] $Amount) {
		$existingItem = $this.Items.Where( {$_.Card.Equals($Card)})
		$totalAmmount = $Amount
		foreach ($item in $existingItem) {
			$totalAmmount += $item.Amount
			$this.Items.Remove($item)
		}
		if ($totalAmmount -gt 0) {
			$this.Items.Add([MTGCollectionItem]::New($Card, $totalAmmount))
		}
	}
	Add([MTGCard] $Card) {
		$this.Add($Card, 1)
	}

	Remove([MTGCard] $Card, [System.Int32] $Amount) {
		$existingItem = $this.Items.Where( {$_.Card.Equals($Card)})
		$totalAmmount = - $Amount
		foreach ($item in $existingItem) {
			$totalAmmount += $item.Amount
			$this.Items.Remove($item)
		}
		if ($totalAmmount -gt 0) {
			$this.Items.Add([MTGCollectionItem]::New($Card, $totalAmmount))
		}
	}
	Remove([MTGCard] $Card) {
		$this.Remove($Card, 1)
	}

	RemoveAll([MTGCard] $Card) {
		$existingItem = $this.Items.Where( {$_.Card.Equals($Card)})
		foreach ($item in $existingItem) {
			$this.Items.Remove($item)
		}
	}
	RemoveAll([System.Boolean] $Confirm) {
		if (!$Confirm) {
			$user = Read-Host -Prompt 'Are you sure you want to remove all cards from this collection? (y/N) '
			$Confirm = ($user -like 'y')
		}
		if ($Confirm) {
			$this.Items = New-Object System.Collections.ArrayList
		}
	}
	RemoveAll() {
		$this.RemoveAll($false)
	}
}

Class MTGWishlistItem {
	[ValidateNotNullOrEmpty()]
	[System.Int32] $Amount
	[ValidateNotNullOrEmpty()]
	[System.String] $Name
	[System.String] $Set

	# Constructor
	MTGWishlistItem ([System.String] $Name) {
		$this.Name = $Name
		$this.Amount = 1
	}
	MTGWishlistItem ([System.String] $Name, [System.String] $Set) {
		$this.Name = $Name
		$this.Amount = 1
		$this.Set = $Set
	}
	MTGWishlistItem ([System.String] $Name, [System.Int32] $Amount) {
		$this.Name = $Name
		$this.Amount = $Amount
	}
	MTGWishlistItem ([System.String] $Name, [System.Int32] $Amount, [System.String] $Set) {
		$this.Name = $Name
		$this.Amount = $Amount
		$this.Set = $Set
	}
}
