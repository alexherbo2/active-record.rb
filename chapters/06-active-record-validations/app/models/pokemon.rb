class Pokemon < ActiveRecord::Base
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
