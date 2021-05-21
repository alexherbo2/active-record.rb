# Validations
# https://guides.rubyonrails.org/active_record_validations.html
module ActiveRecord::Validations
  # Add class methods
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # List of method names to call for #valid?
    def validations
      @validations ||= []
    end

    # Adds a validation method to the class.
    #
    # Example:
    #
    # class Pokemon < ActiveRecord::Base
    #   validate :valid_name?
    #
    #   def valid_name?
    #     name.is_a?(String) && !name.empty? && uniq?(:name)
    #   end
    # end
    #
    # https://guides.rubyonrails.org/active_record_validations.html#custom-methods
    def validate(method_name)
      validations << method_name
    end
  end

  # Runs all validations and returns a boolean.
  # A record is valid if all tests are passing.
  #
  # https://guides.rubyonrails.org/active_record_validations.html#valid-questionmark-and-invalid-questionmark
  def valid?
    self.class.validations.all? do |validation|
      send(validation)
    end
  end

  # Validates whether the value of the specified attributes are unique across the system.
  #
  # Example:
  #
  # class Pokemon < ActiveRecord::Base
  #   validate :valid_name?
  #
  #   def valid_name?
  #     name.is_a?(String) && !name.empty? && uniq?(:name)
  #   end
  # end
  #
  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  def uniq?(*attribute_names)
    # Force type coercion
    attribute_names = attribute_names.map(&:to_s)

    # Build WHERE clause
    clause = attribute_names.map do |name|
      %["#{name}" = :#{name}]
    end.join(' AND ')

    statement = DB.prepare <<~SQL
      SELECT COUNT("id")
      FROM "#{self.class.table_name}"
      WHERE #{clause}
    SQL

    # Count results
    bind_variables = attributes.slice(*attribute_names)
    rows = statement.execute(bind_variables).to_a
    count = rows[0][0]

    # Returns a boolean, true if unique, false otherwise.
    if persisted?
      count.between?(0, 1)
    else
      count.zero?
    end
  end
end
