class Stats < ActiveRecord::Base
  validate :valid_stats?

  def valid_stats?
    attributes.except('id', 'pokemon_id').values.all? do |value|
      value.is_a?(Integer) && value.between?(0, 15)
    end
  end
end
