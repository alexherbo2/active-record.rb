# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the `make db-seed` command (or created alongside the database with `db-setup`).
#
# Reads db/pokemon.json tables and writes to db/{environment}.sqlite3,
# where {environment} is `development` or `test`.

require 'sqlite3'
require 'json'

# Development environment
environment = ENV['ENVIRONMENT']

# Connect to the database
DB = SQLite3::Database.new("db/#{environment}.sqlite3")

# Load Pokémon tables from JSON
tables = File.open('db/pokemon.json') do |file|
  JSON.load(file)
end

# Resets auto-increment of the table columns,
# so that we have a clean state.
#
# https://sqlite.org/autoinc.html
def reset_auto_increment
  DB.execute <<~SQL
    DELETE FROM "sqlite_sequence"
  SQL
end

# Clears the given table.
def clear_table(table_name)
  DB.execute <<~SQL
    DELETE FROM "#{table_name}"
  SQL
end

# Inserts a new record.
def seed(table_name, attributes)
  column_names = attributes.keys

  column_identifiers_fragment = column_names.map do |name|
    %["#{name}"]
  end.join(',')

  column_placeholders_fragment = column_names.map do |name|
    ":#{name}"
  end.join(',')

  statement = DB.prepare <<~SQL
    INSERT INTO "#{table_name}" (#{column_identifiers_fragment})
    VALUES (#{column_placeholders_fragment})
  SQL

  statement.execute(attributes)
end

# Seed database.
# Use a transaction to bulk insert data.
DB.transaction do
  # Reset auto-increment state
  reset_auto_increment

  # Clear tables
  tables.keys.each do |table_name|
    clear_table(table_name)
  end

  # Seed database
  tables.each do |table_name, records|
    records.each do |record|
      seed(table_name, record)
    end
  end
end
