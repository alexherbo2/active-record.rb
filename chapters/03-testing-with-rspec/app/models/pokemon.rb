require 'sqlite3'

class Pokemon
  # Attributes
  attr_reader :id
  attr_accessor :pokemon_number
  attr_accessor :name

  # Returns a new instance.
  #
  # The constructor parameters can be passed in a hash or as a block.
  #
  # Example – Hash:
  #
  # pikachu = Pokemon.new(pokemon_number: 25, name: 'Pikachu')
  #
  # Example – Block:
  #
  # pikachu = Pokemon.new do |pokemon|
  #   pokemon.pokemon_number = 25
  #   pokemon.name = 'Pikachu'
  # end
  def initialize(id: nil, pokemon_number: nil, name: nil, &block)
    # Properties
    @id = id
    @pokemon_number = pokemon_number
    @name = name

    # Accepts a block
    if block_given?
      yield self
    end
  end

  # Creates and saves a new record into the database.
  #
  # Does .new and .save.
  def self.create(...)
    new(...).save
  end

  # Finds a record by its ID.
  #
  # Example:
  #
  # pikachu = Pokemon.find(25)
  def self.find(id)
    find_by('id = ?', id)
  end

  # Returns all records.
  #
  # Example:
  #
  # pokemons = Pokemon.all
  def self.all
    # Get all records
    rows = DB.execute <<~SQL
      SELECT *
      FROM "pokemons"
    SQL

    # Build records
    rows.collect do |row|
      build_record(row)
    end
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
    # Get all records matching the WHERE clause.
    statement = DB.prepare <<~SQL
      SELECT *
      FROM "pokemons"
      WHERE #{clause}
    SQL

    rows = statement.execute(bind_variables).to_a

    # Build records
    rows.collect do |row|
      build_record(row)
    end
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
    # Get all records matching the WHERE clause with a LIMIT set to 1.
    statement = DB.prepare <<~SQL
      SELECT *
      FROM "pokemons"
      WHERE #{clause}
      LIMIT 1
    SQL

    rows = statement.execute(bind_variables).to_a

    # Returns nil if no result
    return nil if rows.empty?

    # Build the first record
    build_record(rows.first)
  end

  # Counts the number of records.
  #
  # Example:
  #
  # pokemon_count = Pokemon.count
  # ⇒ 151
  def self.count
    # Get count
    rows = DB.execute <<~SQL
      SELECT COUNT(id)
      FROM "pokemons"
    SQL

    count = rows[0][0]

    # Returns the number of records.
    count
  end

  # Saves (creates or updates) a record into the database.
  #
  # Called on .create and #update.
  #
  # Example – Create:
  #
  # pikachu = Pokemon.new(pokemon_number: 25, name: 'Pikachu')
  # pikachu.save
  #
  # Example – Update:
  #
  # pikachu.name = 'Pika'
  # pikachu.save
  def save
    if new_record?
      save_new_record
    else
      save_record
    end
  end

  # Updates attributes and saves the record.
  #
  # Updates and .save.
  def update(pokemon_number: @pokemon_number, name: @name)
    # Properties
    @pokemon_number = pokemon_number
    @name = name

    save
  end

  # Returns true if this object hasn’t been saved yet.
  # Otherwise, returns false.
  def new_record?
    !@id
  end

  # Inserts the record into the database,
  # and assigns the ID set by SQLite.
  #
  # Private method called on #save.
  private def save_new_record
    statement = DB.prepare <<~SQL
      INSERT INTO "pokemons" ("pokemon_number", "name")
      VALUES (:pokemon_number, :name)
    SQL

    statement.execute(pokemon_number: @pokemon_number, name: @name)

    # Assign the ID set by SQLite
    @id = DB.last_insert_row_id
  end

  # Updates the record to the database.
  #
  # Private method called on #save.
  private def save_record
    statement = DB.prepare <<~SQL
      UPDATE "pokemons"
      SET "pokemon_number" = :pokemon_number, "name" = :name
      WHERE "id" = :id
    SQL

    statement.execute(id: @id, pokemon_number: @pokemon_number, name: @name)
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
    # Delete the associated row in the database.
    statement = DB.prepare <<~SQL
      DELETE FROM "pokemons"
      WHERE "id" = :id
    SQL

    statement.execute(id: @id)

    # Freeze the record
    freeze
  end

  # Reloads the Pokémon from the database.
  # Returns a new instance.
  #
  # Example:
  #
  # pokemon = pokemon.reload
  def reload
    Pokemon.find(@id)
  end

  # Checks a Pokémon exists in the database.
  #
  # Example:
  #
  # Pokemon.exists?(25)
  # ⇒ true
  def self.exists?(id)
    find(id).instance_of?(self)
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
    Pokemon.exists?(@id)
  end

  # Creates a new instance from a database row.
  #
  # Calls .new with named arguments.
  def self.build_record(row)
    case row
    when SQLite3::ResultSet::ArrayWithTypesAndFields
      build_record_from_array(row)
    when SQLite3::ResultSet::HashWithTypesAndFields
      build_record_from_hash(row)
    end
  end

  # Creates a new instance from a database row as array.
  #
  # Internal method called on .build_record.
  def self.build_record_from_array(row)
    row_as_hash = row.fields.zip(row).to_h

    build_record_from_hash(row_as_hash)
  end

  # Creates a new instance from a database row as hash.
  #
  # Internal method called on .build_record.
  def self.build_record_from_hash(row)
    attributes = row.transform_keys(&:to_sym)

    new(**attributes)
  end
end
