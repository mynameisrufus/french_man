# French Man

Hash and object mocking

## Basic Example

``` ruby
groceries = FrenchMan::Grocery.blueprint {
  garlic { true }
}

groceries.garlic #=> true
groceries[:garlic] #=> true
```

## Bigger Example

``` ruby
groceries = FrenchMan::Grocery.plan {
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

groceries.vino.red #=> "Syrah"
```

## Hash Example
```ruby
groceries = FrenchMan::Grocery.plan :vino => { :red => "Syrah", :white => "Cabernet Sauvignon"}

groceries.vino.red #=> "Syrah"
```
