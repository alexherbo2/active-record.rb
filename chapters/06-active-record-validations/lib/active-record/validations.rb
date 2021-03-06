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
    end
  end

  # Runs all validations and returns a boolean.
  # A record is valid if all tests are passing.
  #
  # https://guides.rubyonrails.org/active_record_validations.html#valid-questionmark-and-invalid-questionmark
  def valid?
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
  end
end
