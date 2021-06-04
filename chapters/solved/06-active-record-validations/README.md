# Active Record – Validations

###### [Previous chapter](../05-active-record-associations-basics) | [Next chapter](../07-make-your-own-gem)

> [Validations] are used to ensure that only valid data is saved into your database.

[Validations]: https://guides.rubyonrails.org/active_record_validations.html

## Why use validations?

Consider for example the following actions:

``` ruby
Pokemon.create(name: 'Bulbasaur', pokemon_number: 1) # ⇒ ok
Pokemon.create(name: 'Ivysaur', pokemon_number: 2) # ⇒ ok
Pokemon.create(name: 'Venusaur', pokemon_number: 3) # ⇒ ok
# ...
Pokemon.create(name: 'Mew', pokemon_number: 151) # ⇒ ok
Pokemon.create(name: 'Mew', pokemon_number: 151) # ⇒ not ok; already exists.
Pokemon.create(name: nil, pokemon_number: nil) # ⇒ not ok; name and Pokémon number cannot be nil.
```

## How to avoid invalid data to be saved into the database?

There are several ways.

### Database constraints

Database constraints is the strongest way, but also the least flexible,
as we want a layer on top of the database to abstract SQL queries with models
(write Ruby code instead of SQL).

### Model-level validations

It’s where the active record pattern kicks in.

Here’s an example of a very simple validation:

[`app/models/pokemon.rb`]

``` ruby
class Pokemon < ActiveRecord::Base
  # Associations
  # ...

  # Validations
  validate :valid_name?

  def valid_name?
    name.present?
  end
end
```

[`app/models/pokemon.rb`]: app/models/pokemon.rb

We have models, declare associations and validations in one place, which is very handy.

### Client-side validations

There is also client-side – JavaScript – validations.
They can provide users with immediate feedback, but are unreliable if used alone,
because they can easily be bypassed.

## When does validation happen?

Validation happens when saving objects.

Update [`ActiveRecord::Base`] to include validations:

``` ruby
require_relative 'validations'

class ActiveRecord::Base
  include ActiveRecord::Validations

  def save(validate: true)
    if validate
      raise 'Invalid record' unless valid?
    end

    if new_record?
      save_new_record
    else
      save_record
    end
  end
end
```

[`ActiveRecord::Base`]: lib/active-record/base.rb

Now, every time you save — create or update — an object, [`valid?`] will be called.

**Example**

``` ruby
pokemon = Pokemon.new
pokemon.name = 'Pikachu'
pokemon.pokemon_number = 25
pokemon.save
```

The [`valid?`] method is not defined yet and will be [the objective of this chapter][Challenge].

## Skipping validations

``` ruby
pokemon = Pokemon.new
pokemon.name = 'MissingNo'
pokemon.pokemon_number = nil
pokemon.save(validate: false) # be cautious
```

## Validations

Validations are method names stored in the `validations` class attribute.

For example, when you declare:

``` ruby
class Pokemon < ActiveRecord::Base
  validate :valid_name?
end
```

The `validations` class attribute contains:

``` ruby
Pokemon.validations # ⇒ [:valid_name?]
```

## The `valid?` method

The [`valid?`] method runs all validations and returns a boolean.
A record is valid if all tests are passing.

[`valid?`]: https://guides.rubyonrails.org/active_record_validations.html#valid-questionmark-and-invalid-questionmark

## Custom methods

You can create [custom methods] that verify the state of your models with the [`validate`] class method,
passing in the symbols for the validation method names.

**Example**

``` ruby
class Pokemon < ActiveRecord::Base
  validate :valid_name?

  def valid_name?
    name.present?
  end
end
```

[Custom methods]: https://guides.rubyonrails.org/active_record_validations.html#custom-methods
[`validate`]: https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validate

## Uniqueness

You can verify the [uniqueness] of the specified attributes with the `uniq?` method.

**Example**

``` ruby
class Pokemon < ActiveRecord::Base
  validate :valid_name?

  def valid_name?
    name.present? and uniq?(:name)
  end
end
```

[Uniqueness]: https://guides.rubyonrails.org/active_record_validations.html#uniqueness

## Challenge

[Challenge]: #challenge

Implement the [`ActiveRecord::Validations`] class, run specs and play with the REPL.

[`ActiveRecord::Validations`]: lib/active-record/validations.rb

**Specs**

``` sh
make test
```

**Playground**

``` sh
make play
```

### Quick start

Open [`lib/active-record/validations.rb`], [`app/models/pokemon.rb`], [`spec/models/pokemon_spec.rb`] and [`data/pokemon.json`].

[`lib/active-record/validations.rb`]: lib/active-record/validations.rb
[`app/models/pokemon.rb`]: app/models/pokemon.rb
[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb
[`data/pokemon.json`]: data/pokemon.json
