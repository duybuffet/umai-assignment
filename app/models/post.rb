require './db/database_connection'

class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :ratings, dependent: :destroy

  validates :title, :content, :author, :author_ip, presence: true

  scope :by_average_rating, -> { order(average_rating: :desc) }
  scope :group_by_author_ip, -> do
    joins(:author)
      .select('posts.author_ip, array_agg(DISTINCT users.login) AS authors')
      .group('posts.author_ip')
  end
end
