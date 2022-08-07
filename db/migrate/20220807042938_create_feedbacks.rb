class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.bigint :owner_id
      t.text :comment
      t.string :feedbackable_type
      t.bigint :feedbackable_id

      t.timestamps
    end

    add_index :feedbacks, [:feedbackable_type, :feedbackable_id, :owner_id], name: 'index_unique_feedback', unique: true
  end
end
