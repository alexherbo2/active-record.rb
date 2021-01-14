module ActiveRecord::Support::Inflector
  # The method `pluralize` returns the plural of its receiver.
  #
  # Examples:
  # – Categor[y] ⇒ Categor[ies]
  # – Weakne[ss] ⇒ Weakness[es]
  # – Stat[s] ⇒ Stats
  # – Pokemon ⇒ Pokemon[s]
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#pluralize
  def self.pluralize(string)
  end

  # The `singularize` method is the inverse of `pluralize`.
  #
  # Examples:
  # – Categor[ies] ⇒ Categor[y]
  # – Weakne[sses] ⇒ Weakness
  # – Weakne[ss] ⇒ Weakness
  # – Pokemon[s] ⇒ Pokemon
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#singularize
  def self.singularize(string)
  end

  # The method `camelize` returns its receiver in camel case.
  #
  # Examples:
  # – pokemon_shiny ⇒ PokemonShiny
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#camelize
  def self.camelize(string)
  end

  # The method `underscore` goes the other way around, from camel case to paths.
  #
  # Examples:
  # – PokemonShiny ⇒ pokemon_shiny
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#underscore
  def self.underscorize(string)
  end

  # Given a string with a qualified constant name, `demodulize` returns the very constant name, that is, the rightmost part of it.
  #
  # Examples:
  # – PokemonGo::Trainer ⇒ Trainer
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#demodulize
  def self.demodulize(string)
  end

  # The method `tableize` is `underscore` followed by `pluralize`.
  #
  # Examples:
  # – PokemonShiny ⇒ pokemon_shinies
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#tableize
  def self.tableize(string)
  end

  # The method `classify` is the inverse of `tableize`.
  # It gives you the class name corresponding to a table name.
  #
  # Examples:
  # – pokemon_shinies ⇒ PokemonShiny
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#classify
  def self.classify(string)
  end

  # The method `constantize` resolves the constant reference expression in its receiver.
  #
  # Examples:
  # – "Pokemon" ⇒ Pokemon
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#constantize
  def self.constantize(string)
  end

  # The method `foreign_key` gives a foreign key column name from a class name.
  # To do so it demodulizes, underscores, and adds `_id`.
  #
  # Examples:
  # – PokemonGo::Trainer ⇒ trainer_id
  #
  # https://guides.rubyonrails.org/active_support_core_extensions.html#foreign-key
  def self.foreign_key(string)
  end
end
