require_relative 'application_serializer'

class PostAverageRatingSerializer < ApplicationSerializer
  attributes :title, :content, :average_rating
end
