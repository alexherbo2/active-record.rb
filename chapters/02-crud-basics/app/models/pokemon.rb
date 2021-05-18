require 'sqlite3'

class Pokemon
  # Attributes
  attr_reader :id
  attr_accessor :index
  attr_accessor :name

  # Returns a new instance.
  #
  # The constructor parameters can be passed in a hash or as a block.
  #
  # Example – Hash:
  #
  # pikachu = Pokemon.new(index: 25, name: 'Pikachu')
  #
  # Example – Block:
  #
  # pikachu = Pokemon.new do |pokemon|
  #   pokemon.index = 25
  #   pokemon.name = 'Pikachu'
  # end
  def initialize(id: nil, index: nil, name: nil, &block)
  end

  # Creates and saves a new record into the database.
  #
  # Does .new and .save.
  def self.create(...)
  end

  # Finds a record by its ID.
  #
  # Example:
  #
  # pikachu = Pokemon.find(25)
  def self.find(id)
  end

  # Returns all records.
  #
  # Example:
  #
  # pokemons = Pokemon.all
  def self.all
  end

  # Returns all records matching the specified conditions.
  #
  # The clause is a string passed to the query constructor as an SQL fragment, and used in the WHERE clause of the query.
  #
  # If no record is found, returns an empty array.
  #
  # Example – Positional placeholders:
  #
  # pokemons = Pokemon.where('name = ?', 'Pikachu')
  #
  # Example – Named placeholders:
  #
  # pokemons = Pokemon.where('name = :name', name: 'Pikachu')
  def self.where(clause, *bind_variables)
  end

  # Finds the first record matching the specified conditions.
  #
  # The clause is a string passed to the query constructor as an SQL fragment, and used in the WHERE clause of the query with a LIMIT set to 1.
  #
  # If no record is found, returns nil.
  #
  # Example – Positional placeholders:
  #
  # pikachu = Pokemon.find_by('name = ?', 'Pikachu')
  #
  # Example – Named placeholders:
  #
  # pikachu = Pokemon.find_by('name = :name', name: 'Pikachu')
  def self.find_by(clause, *bind_variables)
  end

  # Counts the number of records.
  #
  # Example:
  #
  # pokemon_count = Pokemon.count
  # ⇒ 151
  def self.count
  end

  # Saves (creates or updates) a record into the database.
  #
  # Called on .create and #update.
  #
  # Example – Create:
  #
  # pikachu = Pokemon.new(index: 25, name: 'Pikachu')
  # pikachu.save
  #
  # Example – Update:
  #
  # pikachu.name = 'Pika'
  # pikachu.save
  def save
  end

  # Updates attributes and saves the record.
  #
  # Updates and .save.
  def update(index: @index, name: @name)
  end

  # Returns true if this object hasn’t been saved yet.
  # Otherwise, returns false.
  def new_record?
  end

  # Inserts the record into the database,
  # and assigns the ID set by SQLite.
  #
  # Private method called on #save.
  private def save_new_record
  end

  # Updates the record to the database.
  #
  # Private method called on #save.
  private def save_record
  end

  # Deletes the record from the database.
  #
  # Note: The record is frozen, but still valid.
  #
  # Example:
  #
  # pikachu = Pokemon.find(25)
  # pikachu.destroy
  #
  # pikachu.name
  # ⇒ Pikachu
  #
  # pikachu.name = 'Pika'
  # ⇒ Raise an error, because the object has been frozen.
  def destroy
  end

  # Reloads the Pokémon from the database.
  # Returns a new instance.
  #
  # Example:
  #
  # pokemon = pokemon.reload
  def reload
  end

  # Checks a Pokémon exists in the database.
  #
  # Example:
  #
  # Pokemon.exists?(25)
  # ⇒ true
  def self.exists?(id)
  end

  # Checks the Pokémon is persisted in the database.
  #
  # Example:
  #
  # pikachu = Pokemon.find(25)
  # pikachu.persisted?
  # ⇒ true
  #
  # pikachu.destroy
  # pikachu.persisted?
  # ⇒ false
  def persisted?
  end

  # Creates a new instance from a database row.
  #
  # Calls .new with named arguments.
  def self.build_record(row)
  end

  # Creates a new instance from a database row as array.
  #
  # Internal method called on .build_record.
  def self.build_record_from_array(row)
  end

  # Creates a new instance from a database row as hash.
  #
  # Internal method called on .build_record.
  def self.build_record_from_hash(row)
  end
end
