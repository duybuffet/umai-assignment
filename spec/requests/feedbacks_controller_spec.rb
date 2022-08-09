require 'umai_helper'
require_relative '../../application'

RSpec.describe 'FeedbacksController', type: :request do
  include Rack::Test::Methods
  let(:app)      { Application.new }
  let(:headers)   { { 'ACCEPT' => 'application/json' } }
  let(:users) { create_list(:user, 5) }

  describe 'POST /feedbacks' do
    context 'when params is valid' do
      let!(:user) { create(:user) }
      context 'when feedback user' do
        let(:params) do
          {
            'owner_id': 100,
            'comment': 'feedback',
            'user_id': user.id
          }
        end
        it do
          post '/feedbacks', params

          expect(last_response.status).to eq 200
          expect(Feedback.count).to eq(1)
        end
      end
      
      context 'when feedback post' do
        let!(:exist_post) { create(:post) }
        let(:params) do
          {
            'owner_id': 100,
            'comment': 'feedback',
            'post_id': exist_post.id
          }
        end
        it do
          post '/feedbacks', params

          expect(last_response.status).to eq 200
          expect(Feedback.count).to eq(1)
        end
      end
    end

    context 'when params is invalid' do
      context 'when one of attributes is missing' do
        let!(:exist_post) { create(:post) }
        let(:params) do
          {
            'owner_id': 100,
            'comment': 'feedback',
            'post_id': exist_post.id
          }
        end
        ['owner_id', 'comment', 'post_id'].each do |field|
          before do
            params.delete(field.to_sym)
          end
          it do
            post '/feedbacks', params
            expect(last_response.status).to eq 422
            expect(Feedback.count).to eq(0)
          end
        end
      end

      context 'when user_id params does not exist' do
        let(:params) do
          {
            'owner_id': 100,
            'comment': 'feedback',
            'user_id': 'non_exist'
          }
        end
        it do
          post '/feedbacks', params
          expect(last_response.status).to eq 422
          expect(Feedback.count).to eq(0)
        end
      end

      context 'when post_id params does not exist' do
        let(:params) do
          {
            'owner_id': 100,
            'comment': 'feedback',
            'post_id': 'non_exist'
          }
        end
        it do
          post '/feedbacks', params
          expect(last_response.status).to eq 422
          expect(Feedback.count).to eq(0)
        end
      end
    end
  end
end
