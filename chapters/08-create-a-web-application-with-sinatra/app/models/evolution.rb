class Evolution < ActiveRecord::Base
  def pokemon
    Pokemon.find(pokemon_evolution_id)
  end
end
