require_relative 'application_serializer'

class UserSerializer < ApplicationSerializer
  attributes :id, :login
end
