require './db/database_connection'

class Rating < ActiveRecord::Base
  belongs_to :post
end
