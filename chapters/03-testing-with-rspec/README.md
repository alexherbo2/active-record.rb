# Testing with RSpec

This part will be light on my side. 😁

At least, I will not have to write tests.
Instead, I want you to inspect the project structure of the past chapters and write your own tests.

## Before starting

Read [RSpec] and [Better Specs].

[RSpec]: https://rspec.info
[Better Specs]: https://betterspecs.org

## Resources

- [An introduction to RSpec]
- [Getting started with RSpec]

[An introduction to RSpec]: https://blog.teamtreehouse.com/an-introduction-to-rspec
[Getting started with RSpec]: https://semaphoreci.com/community/tutorials/getting-started-with-rspec

## Basics

Open [`spec/models/pokemon_spec.rb`].

[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb

``` ruby
require './app/models/pokemon'

describe Pokemon do
end
```

### Describe methods

Describe methods with examples.

``` ruby
require './app/models/pokemon'

describe Pokemon do
  describe '.new' do
    it 'is a Pokémon' do
      expect(Pokemon.new).to be_a Pokemon
    end
  end
end
```

This one reads as: _new class method: it returns a Pokémon_.

**ProTip!** Describe class methods with `.` and instance methods with `#`.

### Add context

Describe the context under which methods are expected to return given results.

``` ruby
require './app/models/pokemon'

describe Pokemon do
  describe '.new' do
    context 'with parameters' do
      it 'is a Pokémon' do
        expect(Pokemon.new(index: 25, name: 'Pikachu')).to be_a Pokemon
      end
    end

    context 'with block' do
      it 'is a Pokémon' do
        pokemon = Pokemon.new do |pokemon|
          pokemon.index = 25
          pokemon.name = 'Pikachu'
        end

        expect(pokemon).to be_a Pokemon
      end
    end
  end
end
```

This one reads as: _new class method: given parameters, it returns a Pokémon_.

### Use subject and variables

Declare the attributes of your `pokemon` subject.

Use meaningful names, such as `response` or `perform` to test a change.

``` ruby
require './app/models/pokemon'

describe Pokemon do
  describe '.new' do
    # Attributes
    let(:index) { 25 }
    let(:name) { 'Pikachu' }

    context 'with parameters' do
      subject(:pokemon) do
        Pokemon.new(index: index, name: name)
      end

      it 'is a Pokémon' do
        expect(pokemon).to be_a Pokemon
      end
    end

    context 'with block' do
      subject(:pokemon) do
        Pokemon.new do |pokemon|
          pokemon.index = index
          pokemon.name = name
        end
      end

      it 'is a Pokémon' do
        expect(pokemon).to be_a Pokemon
      end
    end
  end
end
```

### Use shared examples

Use shared examples to DRY up your tests.

Shared examples are packages you include in your tests.

``` ruby
require './app/models/pokemon'

describe Pokemon do
  shared_examples 'a Pokémon' do
    it 'is a Pokémon' do
      expect(pokemon).to be_a Pokemon
    end

    it 'has an index' do
      expect(pokemon).to have_attributes index: index
    end

    it 'has a name' do
      expect(pokemon).to have_attributes name: name
    end
  end

  describe '.new' do
    # Attributes
    let(:index) { 25 }
    let(:name) { 'Pikachu' }

    context 'with parameters' do
      subject(:pokemon) do
        Pokemon.new(index: index, name: name)
      end

      it_behaves_like 'a Pokémon'
    end

    context 'with block' do
      subject(:pokemon) do
        Pokemon.new do |pokemon|
          pokemon.index = index
          pokemon.name = name
        end
      end

      it_behaves_like 'a Pokémon'
    end
  end
end
```

### Use shared contexts

Use shared contexts to _compose_ your tests.

Shared contexts are useful to minimize context nesting.

We will use them when adding [associations].

[Associations]: https://guides.rubyonrails.org/association_basics.html

``` ruby
require './app/models/pokemon'

describe Pokemon do
  shared_context 'with a Pokémon' do
    # Declare `pokemon` subject
  end

  shared_context 'with a move' do
    # Add a move to your `pokemon` subject
  end

  describe '#moves' do
    context 'with a Pokémon having a move' do
      include_context 'with a Pokémon'
      include_context 'with a move'

      it { expect(pokemon.moves).to be_an Array }
      it { expect(pokemon.moves).to all be_a Move }
      it { expect(pokemon.moves.size).to eq 1 }
    end
  end
end
```

### Use readable matchers

Your tests should be easily speakable.

``` ruby
require './app/models/pokemon'

describe Pokemon do
  shared_examples 'creates a new Pokémon' do
    it 'increments the number of Pokémon by 1' do
      expect { perform }.to change { Pokemon.count }.by(1)
    end
  end

  describe '.create' do
    # Attributes
    let(:index) { 152 }
    let(:name) { 'Chikorita' }

    context 'with parameters' do
      subject(:perform) do
        Pokemon.create(index: index, name: name)
      end

      include_examples 'creates a new Pokémon'
    end

    context 'with block' do
      subject(:perform) do
        Pokemon.create do |pokemon|
          pokemon.index = index
          pokemon.name = name
        end
      end

      include_examples 'creates a new Pokémon'
    end
  end

  describe '.all' do
    subject(:pokemons) do
      Pokemon.all
    end

    it { expect(pokemons).to be_an Array }
    it { expect(pokemons).to all be_a Pokemon }
    it { expect(pokemons.size).to eq 151 }
  end
end
```

We have used the following matchers:

- [`all`]
- [`be`]
- [`change`]

[`all`]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/all-matcher
[`be`]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/be-matchers
[`change`]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/change-matcher

See the [built-in matchers] for a complete reference.

[Built-in matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

## Challenge

Implement the specs and run `rspec` — or `make test` as before — to ensure my code works as expected.

### Quick start

Open [`app/models/pokemon.rb`], [`spec/models/pokemon_spec.rb`] and [`data/pokemon.json`].

[`app/models/pokemon.rb`]: app/models/pokemon.rb
[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb
[`data/pokemon.json`]: data/pokemon.json

## Solution

[Download solution].

[Download solution]: ../solved/03-testing-with-rspec
