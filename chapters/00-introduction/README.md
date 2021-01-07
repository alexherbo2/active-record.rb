# Introduction

## Overview

**Models**

``` ruby
class Pokemon < ActiveRecord::Base
  has_many :pokemon_moves
  has_many :moves, through: :pokemon_moves
end

class Move < ActiveRecord::Base
end

class PokemonMove < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :move
end
```

**Tables**

``` yaml
pokemons:
  id: integer
  name: string

moves:
  id: integer
  name: string

pokemon_moves:
  id: integer
  pokemon_id: integer
  move_id: integer
```

**Data**

``` yaml
pokemons:
  - id: 1
    name: Pikachu

moves:
  - id: 1
    name: Thunder

pokemon_moves:
  - id: 1
    pokemon_id: 1
    move_id: 1
```

**Example**

``` ruby
Pokemon.all.each do |pokemon|
  puts pokemon.name

  pokemon.moves.each do |move|
    puts move.name
  end
end
```

**Output**

```
Pikachu
Thunder
```
