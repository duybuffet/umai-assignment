require './db/database_connection'

class Rating < ActiveRecord::Base
  belongs_to :post

  validates :rate, numericality: { greater_than: 0, less_than: 6 }

  after_commit :update_post_average_rating, on: :create

  private

  def update_post_average_rating
    return if post.ratings.empty?

    rate_values = post.ratings.pluck(:rate)
    average_values = rate_values.sum / rate_values.size.to_f
    post.update_columns(average_rating: average_values)
  end
end
