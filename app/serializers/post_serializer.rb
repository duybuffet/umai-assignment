require_relative 'application_serializer'

class PostSerializer < ApplicationSerializer
  attributes :id, :title, :content, :author_ip, :average_rating
end
