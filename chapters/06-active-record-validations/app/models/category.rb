class Category < ActiveRecord::Base
  validate :valid_name?

  def valid_name?
    name.is_a?(String) && !name.empty? && uniq?(:name)
  end
end
