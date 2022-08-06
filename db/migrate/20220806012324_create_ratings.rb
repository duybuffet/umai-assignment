class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.references :post, foreign_key: true
      t.integer :rate, limit: 1

      t.timestamps
    end
  end
end
