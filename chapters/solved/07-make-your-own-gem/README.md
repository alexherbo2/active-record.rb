# active-record.rb

An implementation of the [active record pattern] for educational purposes.

[Active record pattern]: https://en.wikipedia.org/wiki/Active_record_pattern

## Dependencies

- [Ruby]

[Ruby]: https://www.ruby-lang.org

## Installation

Run the following in your terminal:

``` sh
make install
```

## Usage

``` ruby
require 'active-record'

class Pokemon < ActiveRecord::Base
end

pikachu = Pokemon.new do |pokemon|
  pokemon.pokemon_number = 25
  pokemon.name = 'Pikachu'
end

pikachu.id
# ⇒ nil (The Pokémon is not persisted yet)

pikachu.save
# Persist the record

pikachu.id
# ⇒ 1 (Expected result, the database has inserted a row, store the ID in memory)

pikachu.name = 'Pika'
pikachu.save
# Update the record in the database
```

See [model][models] examples.

[Models]: app/models

## Documentation

- [Basics]
- [Associations]
- [Validations]

[Basics]: https://guides.rubyonrails.org/active_record_basics.html
[Associations]: https://guides.rubyonrails.org/association_basics.html
[Validations]: https://guides.rubyonrails.org/active_record_validations.html

Read the [source] for a complete reference.

[Source]: lib/active-record/base.rb
