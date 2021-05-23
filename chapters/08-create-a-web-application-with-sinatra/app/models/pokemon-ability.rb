class PokemonAbility < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :ability
end
