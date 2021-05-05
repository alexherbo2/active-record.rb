# Prepare the tables for seeding.

require 'json'

# Load Pokémon from JSON
pokemons = File.open('data/pokemon.json') do |file|
  JSON.load(file)
end

# Tables
tables = {}
tables['pokemons'] = []
tables['categories'] = []
tables['pokemon_categories'] = []
tables['abilities'] = []
tables['pokemon_abilities'] = []
tables['types'] = []
tables['pokemon_types'] = []
tables['stats'] = []
tables['evolutions'] = []

# Prepare the tables to ease seeding.
# Iterates all Pokémon in reverse order to make sure the Pokémon evolution is available for the association.
# Also, gives to Pokémon a stable ID.
pokemons.each.with_index(1).reverse_each do |pokemon, id|
  # Pokémon ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  pokemon_record = {}
  pokemon_record['id'] = id
  pokemon_record['index'] = pokemon['index']
  pokemon_record['name'] = pokemon['name']

  tables['pokemons'].push(pokemon_record)

  # Categories ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  category_record = tables['categories'].find do |category|
    category['name'] == pokemon['category']
  end

  if !category_record
    category_record = {}
    category_record['id'] = tables['categories'].size + 1
    category_record['name'] = pokemon['category']

    tables['categories'].push(category_record)
  end

  # Pokémon category
  pokemon_category_record = {}
  pokemon_category_record['id'] = tables['pokemon_categories'].size + 1
  pokemon_category_record['pokemon_id'] = id
  pokemon_category_record['category_id'] = category_record['id']

  tables['pokemon_categories'].push(pokemon_category_record)

  # Abilities ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  pokemon['abilities'].each do |ability_name|
    ability_record = tables['abilities'].find do |ability|
      ability['name'] == ability_name
    end

    if !ability_record
      ability_record = {}
      ability_record['id'] = tables['abilities'].size + 1
      ability_record['name'] = ability_name

      tables['abilities'].push(ability_record)
    end

    # Pokémon ability
    pokemon_ability_record = {}
    pokemon_ability_record['id'] = tables['pokemon_abilities'].size + 1
    pokemon_ability_record['pokemon_id'] = id
    pokemon_ability_record['ability_id'] = ability_record['id']

    tables['pokemon_abilities'].push(pokemon_ability_record)
  end

  # Types ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  pokemon['type'].each do |type_name|
    type_record = tables['types'].find do |type|
      type['name'] == type_name
    end

    if !type_record
      type_record = {}
      type_record['id'] = tables['types'].size + 1
      type_record['name'] = type_name

      tables['types'].push(type_record)
    end

    # Pokémon type
    pokemon_type_record = {}
    pokemon_type_record['id'] = tables['pokemon_types'].size + 1
    pokemon_type_record['pokemon_id'] = id
    pokemon_type_record['type_id'] = type_record['id']

    tables['pokemon_types'].push(pokemon_type_record)
  end

  # Stats ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  stats_record = {}
  stats_record['id'] = id
  stats_record['hp'] = pokemon['stats']['hp']
  stats_record['attack'] = pokemon['stats']['attack']
  stats_record['defense'] = pokemon['stats']['defense']
  stats_record['special_attack'] = pokemon['stats']['special_attack']
  stats_record['special_defense'] = pokemon['stats']['special_defense']
  stats_record['speed'] = pokemon['stats']['speed']
  stats_record['pokemon_id'] = id

  tables['stats'].push(stats_record)

  # Evolutions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

  pokemon['evolutions'].each do |pokemon_evolution_name|
    # Search for the Pokémon evolution
    pokemon_evolution_record = tables['pokemons'].find do |pokemon|
      pokemon['name'] == pokemon_evolution_name
    end

    # A Pokémon might not have an evolution available,
    # as we only register the first 151 Pokémon.
    #
    # Example: Eevee #133 → Espeon #196
    next unless pokemon_evolution_record

    evolution_record = {}
    evolution_record['id'] = tables['evolutions'].size + 1
    evolution_record['pokemon_id'] = id
    evolution_record['pokemon_evolution_id'] = pokemon_evolution_record['id']

    tables['evolutions'].push(evolution_record)
  end
end

# Restore Pokémon order
tables['pokemons'].reverse!

# Write tables
File.open('db/pokemon.json', 'w') do |file|
  file.puts(JSON.pretty_generate(tables))
end
