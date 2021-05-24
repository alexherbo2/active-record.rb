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
# [{ "index": 1, "name": "Bulbasaur", "types": ["Grass", "Poison"] }, ...]
get '/api/pokemons' do
  content_type 'application/json'

  Pokemon.all.map do |pokemon|
    { index: pokemon.index, name: pokemon.name, types: pokemon.types.map(&:name) }
  end.to_json
end

# Get a Pokémon by its index.
#
# Example:
#
# curl localhost:3000/api/pokemons/25
#
# Response:
#
# { "index": 25, "name": "Pikachu", "types": ["Electric"] }
get '/api/pokemons/:index' do
  content_type 'application/json'

  pokemon = Pokemon.find_by('"index" = ?', params[:index])

  { index: pokemon.index, name: pokemon.name, types: pokemon.types.map(&:name) }.to_json
end
