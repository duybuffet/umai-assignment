class UpdateAverageRatingColumnOfPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :avarage_rating, :average_rating
  end
end
