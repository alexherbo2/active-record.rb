# Active Record – Associations – Basics

What good is an active record library if you can’t connect models?

> Associations are a set of macro-like class methods for tying objects together through foreign keys.
> They express relationships like “`Pokemon` has many `Move`” or “`Pokemon` belongs to a `Category`”.
> Each macro adds a number of methods to the class which are specialized according to the collection or association symbol and the options hash.
> It works much the same way as Ruby’s own attribute methods.

See [Associations] for a complete reference.

[Associations]: https://guides.rubyonrails.org/association_basics.html

## Updating data

It’s time to update our [data] with [Puppeteer].

[Data]: data/pokemon.json
[Puppeteer]: https://pptr.dev

See [Web scraping with Puppeteer] for more details.

[Web scraping with Puppeteer]: ../optional/web-scraping-with-puppeteer

## The `belongs_to` association

A [`belongs_to`] association sets up a connection with another model,
such that each instance of the declaring model “belongs to” one instance of the other model.

[`belongs_to`]: https://guides.rubyonrails.org/association_basics.html#the-belongs-to-association

**Models**

``` ruby
class Pokemon < ActiveRecord::Base
  belongs_to :category
end

class Category < ActiveRecord::Base
end
```

**Tables**

``` yaml
pokemons:
  id: integer
  name: string
  category_id: integer

categories:
  id: integer
  name: string
```

**Options**

``` yaml
class_name: Category
foreign_key: category_id
```

**Expansions**

Doing:

``` ruby
pokemon.category
```

is the same as:

``` ruby
Category.find(pokemon.category_id)
```

## The `has_one` association

A [`has_one`] association indicates that one other model has a reference to this model.
That model can be fetched through this association.

[`has_one`]: https://guides.rubyonrails.org/association_basics.html#the-has-one-association

The main difference from [`belongs_to`] is that the foreign key is located in the other table.

**Models**

``` ruby
class Pokemon < ActiveRecord::Base
  has_one :signature_move
end

class SignatureMove < ActiveRecord::Base
end
```

**Tables**

``` yaml
pokemons:
  id: integer
  name: string

signature_moves:
  id: integer
  name: string
  pokemon_id: integer
```

**Options**

``` yaml
class_name: SignatureMove
foreign_key: pokemon_id
```

**Expansions**

Doing:

``` ruby
pokemon.signature_move
```

is the same as:

``` ruby
SignatureMove.find_by('"pokemon_id" = ?', pokemon.id)
```

## The `has_many` association

A [`has_many`] association is similar to [`has_one`], but indicates a one-to-many connection with another model.
You’ll often find this association on the “other side” of a [`belongs_to`] association.
This association indicates that each instance of the model has zero or more instances of another model.

[`has_many`]: https://guides.rubyonrails.org/association_basics.html#the-has-many-association

**Models**

``` ruby
class Pokemon < ActiveRecord::Base
  has_many :signature_moves
end

class SignatureMove < ActiveRecord::Base
end
```

**Tables**

``` yaml
pokemons:
  id: integer
  name: string

signature_moves:
  id: integer
  name: string
  pokemon_id: integer
```

**Options**

``` yaml
class_name: SignatureMove
foreign_key: pokemon_id
```

**Expansions**

Doing:

``` ruby
pokemon.signature_moves
```

is the same as:

``` ruby
SignatureMove.where('"pokemon_id" = ?', pokemon.id)
```

## The `has_many :through` association

A [`has_many :through`] association is often used to set up a many-to-many connection with another model.
This association indicates that the declaring model can be matched with zero or more instances of another model by proceeding _through_ a third model.

[`has_many :through`]: https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association

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

**Options**

``` yaml
class_name: PokemonMove
foreign_key: pokemon_id
source: move
```

**Expansions**

Doing:

``` ruby
pokemon.moves
```

is the same as:

``` ruby
pokemon.pokemon_moves.map do |pokemon_move|
  pokemon_move.move
end
```

## The `has_one :through` association

A [`has_one :through`] association sets up a one-to-one connection with another model.
This association indicates that the declaring model can be matched with one instance of another model by proceeding _through_ a third model.

[`has_one :through`]: https://guides.rubyonrails.org/association_basics.html#the-has-one-through-association

**Models**

``` ruby
class Pokemon < ActiveRecord::Base
  has_one :pokemon_signature_move
  has_one :signature_move, through: :pokemon_signature_move
end

class SignatureMove < ActiveRecord::Base
end

class PokemonSignatureMove < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :signature_move
end
```

**Tables**

``` yaml
pokemons:
  id: integer
  name: string

signature_moves:
  id: integer
  name: string

pokemon_signature_moves:
  id: integer
  pokemon_id: integer
  signature_move_id: integer
```

**Options**

``` yaml
class_name: PokemonSignatureMove
foreign_key: pokemon_id
source: signature_move
```

**Expansions**

Doing:

``` ruby
pokemon.signature_move
```

is the same as:

``` ruby
pokemon.pokemon_signature_move.signature_move
```

## Challenge

Implement the [`ActiveRecord::Associations`] getter and setter methods (use [`define_method`]), run specs and play with the REPL.

[`ActiveRecord::Associations`]: lib/active-record/associations.rb
[`define_method`]: https://ruby-doc.org/core/Module.html#method-i-define_method

**Specs**

``` sh
make test
```

**Playground**

``` sh
make play
```

**Browser**

Inspect the database with [SQLite Browser]:

``` sh
make db-browse
```

[SQLite Browser]: https://sqlitebrowser.org

Note: Don’t forget to set up the database before.

### Quick start

Open [`lib/active-record/associations.rb`], [`lib/active-record/base.rb`], [`lib/active-record/support/inflector.rb`], [`app/models/pokemon.rb`], [`spec/models/pokemon_spec.rb`] and [`data/pokemon.json`].

[`lib/active-record/associations.rb`]: lib/active-record/associations.rb
[`lib/active-record/base.rb`]: lib/active-record/base.rb
[`lib/active-record/support/inflector.rb`]: lib/active-record/support/inflector.rb
[`app/models/pokemon.rb`]: app/models/pokemon.rb
[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb
[`data/pokemon.json`]: data/pokemon.json

## Solution

[Download solution].

[Download solution]: ../solved/05-active-record-associations-basics
