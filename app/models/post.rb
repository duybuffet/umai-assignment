require './db/database_connection'

class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :ratings, dependent: :destroy

  validates :title, :content, :author, presence: true
end
