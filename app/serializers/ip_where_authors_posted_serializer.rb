require_relative 'application_serializer'

class IpWhereAuthorsPostedSerializer < ApplicationSerializer
  attributes :author_ip, :authors
end
