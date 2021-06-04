# Active Record – Basics

###### [Previous chapter](../03-testing-with-rspec) | [Next chapter](../05-active-record-associations-basics)

Congrats for reaching this exercise.  We will now do some [metaprogramming]; code that produces code.
We can write code to dynamically generate classes, or methods inside a class.
This is very powerful, and quite easily done with Ruby.

[Metaprogramming]: https://en.wikipedia.org/wiki/Metaprogramming

Think about your `Pokemon` class.  You have methods like `#save`, `.find` and `.all`.
Imagine having another model, say `Digimon`.  You will need the exact same methods, right?

This means we want `Pokemon` and `Digimon` to share a common behavior, which can be achieved through inheritance:

``` ruby
class ActiveRecord::Base
  # The shared code
end

class Pokemon < ActiveRecord::Base
end

class Digimon < ActiveRecord::Base
end
```

## Challenge

Implement the [`ActiveRecord::Base`] class, so that it has all the behavior expected from a model, as described in the [CRUD: Reading and writing data] document.

[`ActiveRecord::Base`]: lib/active-record/base.rb
[CRUD: Reading and writing data]: https://guides.rubyonrails.org/active_record_basics.html#crud-reading-and-writing-data

**Example**

``` ruby
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

**Do not** write any code in your `Pokemon` class.
This constraint will help you discover Ruby awesomeness.

Run the specs with `make test` to ensure your code works as expected.

### Quick start

Open [`lib/active-record/base.rb`], [`lib/active-record/support/inflector.rb`], [`app/models/pokemon.rb`], [`spec/models/pokemon_spec.rb`] and [`data/pokemon.json`].

[`lib/active-record/base.rb`]: lib/active-record/base.rb
[`lib/active-record/support/inflector.rb`]: lib/active-record/support/inflector.rb
[`app/models/pokemon.rb`]: app/models/pokemon.rb
[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb
[`data/pokemon.json`]: data/pokemon.json

Move everything from [`Pokemon`] to [`ActiveRecord::Base`].

[`Pokemon`]: ../solved/02-crud-basics/app/models/pokemon.rb
[`ActiveRecord::Base`]: lib/active-record/base.rb

Replace every instance of the `pokemons` table with [`ActiveRecord::Support::Inflector`].

[`ActiveRecord::Support::Inflector`]: lib/active-record/support/inflector.rb

Once you have your table, replace the `id`, `pokemon_number` and `name` columns with safe SQL fragments – placeholders.

You can get the column names of a table with the following Ruby code:

``` ruby
statement = DB.prepare <<~SQL
  SELECT *
  FROM "pokemons"
SQL

statement.columns # ["id", "pokemon_number", "name"]
```

## Solution

[Download solution].

[Download solution]: ../solved/04-active-record-basics

## Credits

This challenge was an exercise I had at [Le Wagon] – Batch `#440`, and motivated me to write this tutorial.

[Le Wagon]: https://lewagon.com

A special mention to [@Lomig] and [@rodloboz] for their help.

[@Lomig]: https://github.com/Lomig
[@rodloboz]: https://github.com/rodloboz
