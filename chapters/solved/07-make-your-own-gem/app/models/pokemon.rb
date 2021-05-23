require './lib/active-record'

# Category
require_relative 'category'
require_relative 'pokemon-category'

# Ability
require_relative 'ability'
require_relative 'pokemon-ability'

# Type
require_relative 'type'
require_relative 'pokemon-type'

# Stats
require_relative 'stats'

# Evolution
require_relative 'evolution'

class Pokemon < ActiveRecord::Base
  # Category
  has_one :pokemon_category
  has_one_through :category, :pokemon_category

  # Abilities
  has_many :pokemon_abilities
  has_many_through :abilities, :pokemon_abilities

  # Types
  has_many :pokemon_types
  has_many_through :types, :pokemon_types

  # Stats
  has_one :stats, class_name: 'Stats'

  # Evolutions
  has_many :evolutions

  # Validations
  validate :valid_index?
  validate :valid_name?

  def valid_index?
    index.is_a?(Integer) && index.positive? && uniq?(:index)
  end

  def valid_name?
    name.is_a?(String) && !name.empty? && uniq?(:name)
  end
end
