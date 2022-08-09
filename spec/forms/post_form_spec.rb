require 'umai_helper'
require_relative '../../application'

RSpec.describe 'PostForm', type: :form do
  describe '#submit' do
    let(:form) { PostForm.new(post, params) }

    context 'when params valid' do
      let(:params) { { title: 'title', content: 'content', author_ip: '11.22.33.44', login: 'username' } }
      let(:post) { Post.new }
      it 'should save post to database' do
        res = form.submit
        expect(res).to eq(true)
        expect(Post.count).to eq(1)
      end
    end

    context 'when params invalid' do
      let(:params) { { title: 'title', content: 'content', author_ip: '11.22.33.44', login: 'username' } }
      let(:post) { Post.new }
      %i[title content author_ip login].each do |key|
        before do
          params.delete(key)
        end
        it 'should not save post to database' do
          res = form.submit
          expect(res).to eq(false)
        end
      end
    end
  end
end
