require './db/database_connection'

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :ratings, dependent: :destroy
end
