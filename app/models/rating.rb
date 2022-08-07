require './db/database_connection'

class Rating < ActiveRecord::Base
  belongs_to :post

  validates :rate, numericality: { greater_than: 0, less_than: 6 }

  after_commit :update_post_avarage_rating, on: :create

  private

  def update_post_avarage_rating
    return if post.ratings.empty?

    rate_values = post.ratings.pluck(:rate)
    avarage_values = rate_values.sum / rate_values.size.to_f
    post.update_columns(avarage_rating: avarage_values)
  end
end
