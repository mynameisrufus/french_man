# French Man

Hash and object mocking

## Usage

``` ruby
groceries = FrenchMan::Grocery.blueprint {
  garlic { true }
}

groceries.garlic #=> true

vino = FrenchMan::Vino.blueprint {
  red { 'tempranillo' }
  white { 'sav' }
}

vino.red #=> "tempranillo"
```

## More Usage

``` ruby
shopping = FrenchMan::Foodofafa.plan {
  groceries {
    FrenchMan::Grocery.plan {
      vino {
        FrenchMan::Vino.plan {
          red { "Syrah" }
          white { "Cabernet Sauvignon" }
        }
      }
      cheeses {
        ['Camembert', 'Crotin du Chavignol']
      }
    }
  }
}

# object style
shopping.groceries.vino.red #=> "Syrah"

# hash style
shopping[:groceries][:vino][:red] #=> "Syrah"
```
