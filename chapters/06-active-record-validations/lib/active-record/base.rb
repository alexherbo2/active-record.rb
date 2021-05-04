class ActiveRecord::Base
  include ActiveRecord::Validations

  def save
    raise 'Invalid record' unless valid?

    ...
  end
end
