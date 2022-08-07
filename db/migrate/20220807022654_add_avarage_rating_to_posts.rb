class AddAvarageRatingToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :avarage_rating, :decimal, null: false, precision: 2, scale: 1, default: '0.0'
  end
end
