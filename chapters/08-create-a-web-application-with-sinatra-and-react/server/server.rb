require 'sinatra'
require 'json'
require 'active-record'
require 'sqlite3'

require './app/models/pokemon'

# Connect to the database
DB = SQLite3::Database.new('db/development.sqlite3')

# Configuration
# http://sinatrarb.com/configuration.html
set :static, true
set :public_folder, '../client'
set :port, 3000

# Routes
get '/' do
  content_type 'text/html'
  send_file '../client/index.html'
end

# API ──────────────────────────────────────────────────────────────────────────

# Get all Pokémon.
#
# Example:
#
# curl localhost:3000/api/pokemons
#
# Response:
#
# [{ "pokemon_number": 1, "name": "Bulbasaur", "types": ["Grass", "Poison"] }, ...]
get '/api/pokemons' do
  content_type 'application/json'

  Pokemon.all.map do |pokemon|
    { pokemon_number: pokemon.pokemon_number, name: pokemon.name, types: pokemon.types.map(&:name) }
  end.to_json
end

# Get a Pokémon by its National Pokédex number.
#
# Example:
#
# curl localhost:3000/api/pokemons/25
#
# Response:
#
# { "pokemon_number": 25, "name": "Pikachu", "types": ["Electric"] }
get '/api/pokemons/:pokemon_number' do
  content_type 'application/json'

  pokemon = Pokemon.find_by('"pokemon_number" = ?', params[:pokemon_number])

  { pokemon_number: pokemon.pokemon_number, name: pokemon.name, types: pokemon.types.map(&:name) }.to_json
end
