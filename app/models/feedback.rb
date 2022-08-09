require './db/database_connection'

class Feedback < ActiveRecord::Base
  belongs_to :feedbackable, polymorphic: true
  validates :owner_id, numericality: { only_integer: true }
  validates :owner_id, :comment, presence: true
  validates :owner_id, uniqueness: { scope: [:feedbackable_type, :feedbackable_id] }

  scope :from_owner, ->(owner_id) { where(owner_id: owner_id) }

  def owner_login
    return feedbackable.author.login if feedbackable_type == 'Post'

    return feedbackable.login if feedbackable_type == 'User'

    nil
  end
end
