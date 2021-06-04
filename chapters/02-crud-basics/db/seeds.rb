# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the `make db-seed` command (or created alongside the database with `db-setup`).

require 'sqlite3'
require 'json'

# Development environment
environment = ENV['ENVIRONMENT']

# Connect to the database
DB = SQLite3::Database.new("db/#{environment}.sqlite3")

# Load Pokémon from JSON
pokemons = File.open('data/pokemon.json') do |file|
  JSON.load(file)
end

# SQL statement to reset AUTOINCREMENT of the table columns,
# so that we have a clean state.
#
# https://sqlite.org/autoinc.html
reset_auto_increment_statement = DB.prepare <<~SQL
  DELETE FROM "sqlite_sequence"
SQL

# SQL statement to delete all Pokémon from the database,
# so that we have a clean state.
delete_pokemons_statement = DB.prepare <<~SQL
  DELETE FROM "pokemons"
SQL

# SQL statement to insert a Pokémon into the database.
insert_pokemon_statement = DB.prepare <<~SQL
  INSERT INTO "pokemons" ("pokemon_number", "name")
  VALUES (:pokemon_number, :name)
SQL

# Seed data
# Use a transaction to bulk insert data.
DB.transaction do
  # Clean
  reset_auto_increment_statement.execute
  delete_pokemons_statement.execute

  # Insert
  pokemons.each do |pokemon|
    insert_pokemon_statement.execute(pokemon)
  end
end
