require_relative 'application_serializer'

class FeedbackSerializer < ApplicationSerializer
  attributes :id, :comment, :owner_id
end
