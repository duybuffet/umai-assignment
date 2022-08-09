require 'umai_helper'
require_relative '../../application'

RSpec.describe Post, type: :model do
  describe 'validate' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:author_ip) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
  end
end
