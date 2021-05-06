# Associations
# https://guides.rubyonrails.org/association_basics.html
module ActiveRecord::Associations
  # A `belongs_to` association sets up a connection with another model,
  # such that each instance of the declaring model “belongs to” one instance of the other model.
  #
  # Models ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class Pokemon < ActiveRecord::Base
  #   belongs_to :category
  # end
  #
  # class Category < ActiveRecord::Base
  # end
  #
  # Tables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # pokemons:
  #   id: integer
  #   name: string
  #   category_id: integer
  #
  # categories:
  #   id: integer
  #   name: string
  #
  # Options ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class_name: Category
  # foreign_key: category_id
  #
  # Expansions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # Doing:
  #
  # pokemon.category
  #
  # is the same as:
  #
  # Category.find(pokemon.category_id)
  #
  # https://guides.rubyonrails.org/association_basics.html#the-belongs-to-association
  def belongs_to(association_name,
    class_name: ActiveRecord::Support::Inflector.classify(association_name),
    foreign_key: ActiveRecord::Support::Inflector.foreign_key(association_name)
  )
    define_method(association_name) do
      association_model = ActiveRecord::Support::Inflector.constantize(class_name)
      association_id = send(foreign_key)
      association_model.find(association_id)
    end
  end

  # A `has_one` association indicates that one other model has a reference to this model.
  # That model can be fetched through this association.
  #
  # The main difference from `belongs_to` is that the foreign key is located in the other table.
  #
  # Models ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class Pokemon < ActiveRecord::Base
  #   has_one :signature_move
  # end
  #
  # class SignatureMove < ActiveRecord::Base
  # end
  #
  # Tables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # pokemons:
  #   id: integer
  #   name: string
  #
  # signature_moves:
  #   id: integer
  #   name: string
  #   pokemon_id: integer
  #
  # Options ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class_name: SignatureMove
  # foreign_key: pokemon_id
  #
  # Expansions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # Doing:
  #
  # pokemon.signature_move
  #
  # is the same as:
  #
  # SignatureMove.find_by('"pokemon_id" = ?', pokemon.id)
  #
  # https://guides.rubyonrails.org/association_basics.html#the-has-one-association
  def has_one(association_name,
    class_name: ActiveRecord::Support::Inflector.classify(association_name),
    foreign_key: ActiveRecord::Support::Inflector.foreign_key(name)
  )
    define_method(association_name) do
      association_model = ActiveRecord::Support::Inflector.constantize(class_name)
      association_model.find_by(%["#{foreign_key}" = ?], id)
    end
  end

  # A `has_many` association is similar to `has_one`, but indicates a one-to-many connection with another model.
  # You’ll often find this association on the “other side” of a `belongs_to` association.
  # This association indicates that each instance of the model has zero or more instances of another model.
  #
  # Models ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class Pokemon < ActiveRecord::Base
  #   has_many :signature_moves
  # end
  #
  # class SignatureMove < ActiveRecord::Base
  # end
  #
  # Tables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # pokemons:
  #   id: integer
  #   name: string
  #
  # signature_moves:
  #   id: integer
  #   name: string
  #   pokemon_id: integer
  #
  # Options ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class_name: SignatureMove
  # foreign_key: pokemon_id
  #
  # Expansions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # Doing:
  #
  # pokemon.signature_moves
  #
  # is the same as:
  #
  # SignatureMove.where('"pokemon_id" = ?', pokemon.id)
  #
  # https://guides.rubyonrails.org/association_basics.html#the-has-many-association
  def has_many(association_name,
    class_name: ActiveRecord::Support::Inflector.classify(association_name),
    foreign_key: ActiveRecord::Support::Inflector.foreign_key(name)
  )
    define_method(association_name) do
      association_model = ActiveRecord::Support::Inflector.constantize(class_name)
      association_model.where(%["#{foreign_key}" = ?], id)
    end
  end

  # A `has_many :through` association is often used to set up a many-to-many connection with another model.
  # This association indicates that the declaring model can be matched with zero or more instances of another model by proceeding _through_ a third model.
  #
  # Models ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class Pokemon < ActiveRecord::Base
  #   has_many :pokemon_moves
  #   has_many :moves, through: :pokemon_moves
  # end
  #
  # class Move < ActiveRecord::Base
  # end
  #
  # class PokemonMove < ActiveRecord::Base
  #   belongs_to :pokemon
  #   belongs_to :move
  # end
  #
  # Tables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # pokemons:
  #   id: integer
  #   name: string
  #
  # moves:
  #   id: integer
  #   name: string
  #
  # pokemon_moves:
  #   id: integer
  #   pokemon_id: integer
  #   move_id: integer
  #
  # Options ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # source: move
  #
  # Expansions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # Doing:
  #
  # pokemon.moves
  #
  # is the same as:
  #
  # pokemon.pokemon_moves.map do |pokemon_move|
  #   pokemon_move.move
  # end
  #
  # https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association
  def has_many_through(association_name, through_association_name,
    source: ActiveRecord::Support::Inflector.singularize(association_name)
  )
    define_method(association_name) do
      send(through_association_name).map do |model|
        model.send(source)
      end
    end
  end

  # A `has_one :through` association sets up a one-to-one connection with another model.
  # This association indicates that the declaring model can be matched with one instance of another model by proceeding _through_ a third model.
  #
  # Models ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # class Pokemon < ActiveRecord::Base
  #   has_one :pokemon_signature_move
  #   has_one :signature_move, through: :pokemon_signature_move
  # end
  #
  # class SignatureMove < ActiveRecord::Base
  # end
  #
  # class PokemonSignatureMove < ActiveRecord::Base
  #   belongs_to :pokemon
  #   belongs_to :signature_move
  # end
  #
  # Tables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # pokemons:
  #   id: integer
  #   name: string
  #
  # signature_moves:
  #   id: integer
  #   name: string
  #
  # pokemon_signature_moves:
  #   id: integer
  #   pokemon_id: integer
  #   signature_move_id: integer
  #
  # Options ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # source: signature_move
  #
  # Expansions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈
  #
  # Doing:
  #
  # pokemon.signature_move
  #
  # is the same as:
  #
  # pokemon.pokemon_signature_move.signature_move
  #
  # https://guides.rubyonrails.org/association_basics.html#the-has-one-through-association
  def has_one_through(association_name, through_association_name,
    source: association_name
  )
    define_method(association_name) do
      send(through_association_name).send(source)
    end
  end
end
