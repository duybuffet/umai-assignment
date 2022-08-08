class AddIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :posts, :average_rating
  end
end
