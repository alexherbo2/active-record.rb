# Mapping between models and database tables

###### [Previous chapter](../00-introduction) | [Next chapter](../02-crud-basics)

> By default, [Active Record] uses some naming conventions to find out how the mapping between models and database tables should be created.

Model | Table | Foreign key
--- | --- | ---
Pokemon | pokemons | pokemon_id
Move | moves | move_id
PokemonMove | pokemon_moves | pokemon_move_id

See [Naming conventions] for more details.

[Active Record]: https://guides.rubyonrails.org/active_record_basics.html
[Naming conventions]: https://guides.rubyonrails.org/active_record_basics.html#naming-conventions

It allows you to write:

``` ruby
class Pokemon < ActiveRecord::Base
  has_many :pokemon_moves
  has_many :moves, through: :pokemon_moves
end
```

instead of:

``` ruby
class Pokemon < ActiveRecord::Base
  self.table_name = 'pokemons'
  has_many :pokemon_moves, class_name: 'PokemonMove', foreign_key: 'pokemon_id'
  has_many :moves, through: :pokemon_moves, source: :move
end
```

By that, you should understand
`pokemon.moves` as `pokemon.pokemon_moves.map(&:move)` and
`pokemon.pokemon_moves` as `PokemonMove.where('pokemon_id = ?', pokemon.id)`.

In order to do that, we will need the following methods:

- [`pluralize`]
- [`singularize`]
- [`camelize`]
- [`underscore`]
- [`demodulize`]
- [`tableize`]
- [`classify`]
- [`constantize`]
- [`foreign_key`]

[`pluralize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#pluralize
[`singularize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#singularize
[`camelize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#camelize
[`underscore`]: https://guides.rubyonrails.org/active_support_core_extensions.html#underscore
[`demodulize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#demodulize
[`tableize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#tableize
[`classify`]: https://guides.rubyonrails.org/active_support_core_extensions.html#classify
[`constantize`]: https://guides.rubyonrails.org/active_support_core_extensions.html#constantize
[`foreign_key`]: https://guides.rubyonrails.org/active_support_core_extensions.html#foreign_key

See [Inflections] for a complete reference.

[Inflections]: https://guides.rubyonrails.org/active_support_core_extensions.html#inflections

## Challenge

Implement the [`ActiveRecord::Support::Inflector`] class, run specs and play with the REPL.

[`ActiveRecord::Support::Inflector`]: lib/active-record/support/inflector.rb

**Specs**

``` sh
make test
```

**Playground**

``` sh
make play
```

### Quick start

Open [`lib/active-record/support/inflector.rb`], [`spec/active-record/support/inflector_spec.rb`] and [`spec/data/inflections.json`].

[`lib/active-record/support/inflector.rb`]: lib/active-record/support/inflector.rb
[`spec/active-record/support/inflector_spec.rb`]: spec/active-record/support/inflector_spec.rb
[`spec/data/inflections.json`]: spec/data/inflections.json
