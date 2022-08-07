require './db/database_connection'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates :login, presence: true
end
