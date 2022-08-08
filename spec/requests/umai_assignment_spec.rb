require 'umai_helper'
require_relative '../../application'

FactoryBot.define do
  factory :user do
    login { Faker::Internet.username(specifier: 10) }
  end

  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(sentence_count: (5..10).to_a.sample) }
    author_ip { Faker::Internet.public_ip_v4_address }
    association :author, factory: :user
  end

  factory :feedback do
    owner_id { rand(1..10_000) }
    comment { Faker::Lorem.sentence }
  end
end

RSpec.describe 'UmaiAssignment', type: :request do
  include Rack::Test::Methods
  let(:app)      { Application.new }
  let(:headers)   { { 'ACCEPT' => 'application/json' } }
  let(:users) { create_list(:user, 5) }

  describe 'PostsController' do
    context 'GET /posts' do
      let!(:posts) { create_list(:post, 50, author: users.sample, average_rating: (1..5).to_a.sample) }
      context 'when number of record is specified' do
        it do
          get '/posts', items: 40
          response = JSON.parse(last_response.body)
          expect(response['data'].size).to eq 40
          expect(response['meta']['pages']).to eq 2
          expect(last_response.status).to eq 200
        end
      end

      context 'when number of record is not specified, default is 25 items in a page' do
        it do
          get '/posts'
          response = JSON.parse(last_response.body)
          expect(response['data'].size).to eq 25
          expect(response['meta']['pages']).to eq 2
          expect(last_response.status).to eq 200
        end
      end

      context 'when getting top N average rating post' do
        it do
          get '/posts', count: 5, top_average_rating: true
          response = JSON.parse(last_response.body)
          expect(response['data'].size).to eq 5
          expect(response['data'].map { |item| item['id'] }).to eq Post.by_average_rating.limit(5).pluck(:id).map(&:to_s)
          expect(last_response.status).to eq 200
        end
      end
    end

    context 'POST /posts' do
      context 'when params is valid' do
        context 'when user login not exist yet' do
          let(:params) do
            {
              'title': 'title',
              'content': 'content',
              'login': 'new_login',
              'author_ip': '444.12.33.33'
            }
          end
          it do
            post '/posts', params

            expect(last_response.status).to eq 200
            expect(Post.count).to eq(1)
            expect(User.last.login).to eq('new_login')
          end
        end
        
        context 'when user login does exist ' do
          let!(:user) { create(:user, login: 'exist') }
          let(:params) do
            {
              'title': 'title',
              'content': 'content',
              'login': 'exist',
              'author_ip': '444.12.33.33'
            }
          end
          it do
            expect(User.count).to eq(1)
            post '/posts', params

            expect(last_response.status).to eq 200
            expect(User.count).to eq(1)
          end
        end
      end

      context 'when params is invalid' do
        let(:params) do
          {
            'title': 'title',
            'content': 'content',
            'login': 'exist',
            'author_ip': '444.12.33.33'
          }
        end
        ['title', 'content', 'author_id', 'login'].each do |field|
          before do
            params.delete(field.to_sym)
          end
          it do
            post '/posts', params
            expect(last_response.status).to eq 422
            expect(User.count).to eq(0)
          end
        end
        
      end
    end
  end
end
