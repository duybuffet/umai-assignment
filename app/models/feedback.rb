require './db/database_connection'

class Feedback < ActiveRecord::Base
  belongs_to :feedbackable, polymorphic: true
  validates :owner_id, numericality: { only_integer: true }
  validates :owner_id, :comment, presence: true
  validates :owner_id, uniqueness: { scope: [:feedbackable_type, :feedbackable_id] }

  scope :from_owner, ->(owner_id) { where(owner_id: owner_id) }
end
