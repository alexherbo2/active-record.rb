require 'sqlite3'
require './app/models/pokemon'

# Connect to the database
DB = SQLite3::Database.new('db/development.sqlite3')

puts 'Type DB.▌ or Pokemon.▌ and play with the methods'
puts 'Note: Before using the Pokemon class, do not forget to initialize the table structure with the `make db-create` command.'
puts 'For a quick start, you might like `make db-setup` which is an alias to `make db-drop db-create db-seed`.'
puts 'Do not hesitate to open the Makefile to see how the dance is done.'
