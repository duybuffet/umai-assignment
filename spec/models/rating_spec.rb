require 'umai_helper'
require_relative '../../application'

RSpec.describe Rating, type: :model do
  describe 'validate' do
    it { is_expected.to validate_presence_of(:post) }
    it { is_expected.to validate_numericality_of(:rate).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:rate).is_less_than(6) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:post) }
  end
end
