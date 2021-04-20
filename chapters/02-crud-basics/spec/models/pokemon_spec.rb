require './app/models/pokemon'

# Connect to the database
DB = SQLite3::Database.new('db/test.sqlite3')

# Initialize the database and seed data
system('make', '-s', 'db-setup')

describe Pokemon do
  # Restore data before each test to have a clean state.
  before(:each) do
    IO.copy_stream('db/development.sqlite3', DB.filename)
  end

  # The `pokemon` subject is a `Pokemon`.
  # It has an `index` and a `name`.
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

  # Creates a new Pokémon.
  # It `perform` a change with an expected result.
  shared_examples 'creates a new Pokémon' do
    it 'increments the number of Pokémon by 1' do
      expect { perform }.to change { Pokemon.count }.by(1)
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

  describe '.create' do
    # Attributes
    let(:index) { 25 }
    let(:name) { 'Pikachu' }

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

  describe '.find' do
    context 'when found' do
      # Attributes
      let(:id) { 25 }
      let(:index) { 25 }
      let(:name) { 'Pikachu' }

      subject(:pokemon) do
        Pokemon.find(id)
      end

      it_behaves_like 'a Pokémon'
    end

    context 'when not found' do
      # Attributes
      let(:id) { 0 }

      subject do
        Pokemon.find(id)
      end

      it { is_expected.to be_nil }
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

  describe '.where' do
    context 'when found' do
      # Attributes
      let(:name) { 'Pikachu' }

      subject(:pokemons) do
        Pokemon.where('name = ?', name)
      end

      it { expect(pokemons).to be_an Array }
      it { expect(pokemons).to all be_a Pokemon }
      it { expect(pokemons.size).to eq 1 }
    end

    context 'when not found' do
      subject(:pokemons) do
        Pokemon.where('name = "???"')
      end

      it { expect(pokemons).to be_an Array }
      it { expect(pokemons).to be_empty }
    end
  end

  describe '.find_by' do
    # Attributes
    let(:id) { 25 }
    let(:index) { 25 }
    let(:name) { 'Pikachu' }

    context 'when found' do
      subject(:pokemon) do
        Pokemon.find_by('name = ?', name)
      end

      it_behaves_like 'a Pokémon'
    end

    context 'when not found' do
      subject do
        Pokemon.find_by('name = "???"')
      end

      it { is_expected.to be_nil }
    end
  end

  describe '.count' do
    let(:count) do
      Pokemon.count
    end

    it { expect(count).to eq 151 }
  end

  describe '#save' do
    context 'with a new Pokémon' do
      # Attributes
      let(:index) { 152 }
      let(:name) { 'Chikorita' }

      subject(:pokemon) do
        Pokemon.new(index: index, name: name)
      end

      subject(:perform) do
        pokemon.save
      end

      include_examples 'creates a new Pokémon'
    end

    context 'with an existing Pokémon' do
      # Attributes
      let(:id) { 25 }
      let(:name) { 'Pikachu' }
      let(:new_name) { 'Pika' }

      subject(:pokemon) do
        Pokemon.find(id)
      end

      subject(:perform) do
        pokemon.name = new_name
        pokemon.save
      end

      it 'changes the name of the Pokémon' do
        expect { perform }.to change { pokemon.reload.name }.from(name).to(new_name)
      end
    end
  end

  describe '#update' do
    # Attributes
    let(:id) { 25 }
    let(:name) { 'Pikachu' }
    let(:new_name) { 'Pika' }

    subject(:pokemon) do
      Pokemon.find(id)
    end

    subject(:perform) do
      pokemon.update(name: new_name)
    end

    it 'changes the name of the Pokémon' do
      expect { perform }.to change { pokemon.reload.name }.from(name).to(new_name)
    end
  end

  describe '#destroy' do
    context 'with an existing Pokémon' do
      # Attributes
      let(:id) { 25 }

      subject(:pokemon) do
        Pokemon.find(id)
      end

      subject(:perform) do
        pokemon.destroy
      end

      it 'decrements the number of Pokémon by 1' do
        expect { perform }.to change { Pokemon.count }.by(-1)
      end

      it 'freezes the record' do
        perform

        expect(pokemon).to be_frozen
      end
    end

    context 'with a new Pokémon' do
      # Attributes
      let(:index) { 152 }
      let(:name) { 'Chikorita' }

      subject(:pokemon) do
        Pokemon.new(index: index, name: name)
      end

      subject(:perform) do
        pokemon.destroy
      end

      it 'does not change the number of Pokémon' do
        expect { perform }.not_to change { Pokemon.count }
      end
    end
  end

  describe '#reload' do
    # Attributes
    let(:id) { 25 }
    let(:name) { 'Pikachu' }
    let(:new_name) { 'Pika' }

    subject(:pokemon) do
      pokemon = Pokemon.find(id)
    end

    it 'reloads the Pokémon from the database' do
      pokemon.name = new_name

      expect(pokemon.reload).to have_attributes name: name
    end
  end

  describe '.exists?' do
    context 'when found' do
      # Attributes
      let(:id) { 25 }

      let(:response) do
        Pokemon.exists?(id)
      end

      it 'returns true' do
        expect(response).to be true
      end
    end

    context 'when not found' do
      # Attributes
      let(:id) { 0 }

      let(:response) do
        Pokemon.exists?(id)
      end

      it 'returns false' do
        expect(response).to be false
      end
    end
  end

  describe '#persisted?' do
    context 'when found' do
      # Attributes
      let(:id) { 25 }

      subject(:pokemon) do
        Pokemon.find(id)
      end

      let(:response) do
        pokemon.persisted?
      end

      it 'returns true' do
        expect(response).to be true
      end
    end

    context 'when not found' do
      # Attributes
      let(:index) { 25 }
      let(:name) { 'Pikachu' }

      subject(:pokemon) do
        Pokemon.new(index: index, name: name)
      end

      let(:response) do
        pokemon.persisted?
      end

      it 'returns false' do
        expect(response).to be false
      end
    end
  end
end
