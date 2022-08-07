require 'active_model'

class ApplicationForm
  include ActiveModel::Model

  def persisted?
    fail NotImplementedError, "You must define `persisted?` as instance method in #{self.class.name} class."
  end
end
