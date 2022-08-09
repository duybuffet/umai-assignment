require 'umai_helper'
require_relative '../../application'

RSpec.describe Feedback, type: :model do
  describe 'validate' do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_numericality_of(:owner_id) }
    it { is_expected.to validate_uniqueness_of(:owner_id).scoped_to(:feedbackable_type, :feedbackable_id) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:feedbackable) }
  end
end
