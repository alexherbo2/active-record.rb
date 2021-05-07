class PokemonCategory < ActiveRecord::Base
  belongs_to :pokemon
  belongs_to :category
end
