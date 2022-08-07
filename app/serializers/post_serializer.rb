require_relative 'application_serializer'

class PostSerializer < ApplicationSerializer
  attributes :id, :title, :content, :author_ip, :avarage_rating
end
