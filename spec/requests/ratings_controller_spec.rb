require 'umai_helper'
require_relative '../../application'

RSpec.describe 'RatingsController', type: :request do
  include Rack::Test::Methods
  let(:app)      { Application.new }
  let(:headers)   { { 'ACCEPT' => 'application/json' } }

  describe 'POST /ratings' do
    context 'when params is valid' do
      let!(:existing_post) { create(:post) }
      let(:params_1) do
        {
          'post_id': existing_post.id,
          'rate': 5
        }
      end
      let(:params_2) do
        {
          'post_id': existing_post.id,
          'rate': 1
        }
      end
      it 'should calculate average rating of post' do
        post '/ratings', params_1

        expect(last_response.status).to eq 200
        expect(existing_post.reload.average_rating).to eq(5)

        post '/ratings', params_2

        expect(last_response.status).to eq 200
        expect(existing_post.reload.average_rating).to eq(3)

        expect(Rating.count).to eq(2)
      end
    end

    context 'when params is invalid' do
      let!(:existing_post) { create(:post) }
      context 'when one of attributes is missing' do
        let(:params) do
          {
            'post_id': existing_post.id,
            'rate': 5
          }
        end
        ['rate', 'post_id'].each do |field|
          before do
            params.delete(field.to_sym)
          end
          it do
            post '/ratings', params
            expect(last_response.status).to eq 422
            expect(Rating.count).to eq(0)
          end
        end
      end

      context 'when rate is not a number' do
        let(:params) do
          {
            'post_id': existing_post.id,
            'rate': 'text'
          }
        end
        ['rate', 'post_id'].each do |field|
          before do
            params.delete(field.to_sym)
          end
          it do
            post '/ratings', params
            expect(last_response.status).to eq 422
            expect(Rating.count).to eq(0)
          end
        end
      end
    end
  end
end
