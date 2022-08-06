class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.string :author_ip

      t.timestamps
    end
  end
end
