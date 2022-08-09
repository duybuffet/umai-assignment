require 'umai_helper'
require_relative '../../application'

RSpec.describe 'FeedbackForm', type: :form do
  describe '#submit' do
    let(:form) { FeedbackForm.new(feedback, params) }

    context 'when params valid' do
      context 'when feedback user' do
        let(:params) { { owner_id: rand(1..50), comment: 'comment', user_id: user.id } }
        let(:user) { create(:user) }
        let(:feedback) { Feedback.new }
        it 'should save feedback to database' do
          res = form.submit
          expect(res).to eq(true)
          expect(Feedback.count).to eq(1)
          expect(form.feedback.feedbackable_id).to eq(user.id)
          expect(form.feedback.feedbackable_type).to eq('User')
        end
      end

      context 'when feedback user' do
        let(:params) { { owner_id: rand(1..50), comment: 'comment', post_id: post.id } }
        let(:post) { create(:post) }
        let(:feedback) { Feedback.new }
        it 'should save feedback to database' do
          res = form.submit
          expect(res).to eq(true)
          expect(Feedback.count).to eq(1)
          expect(form.feedback.feedbackable_id).to eq(post.id)
          expect(form.feedback.feedbackable_type).to eq('Post')
        end
      end
    end

    context 'when params invalid' do
      let(:params) { { comment: 'comment', owner_id: 12, post_id: post.id } }
      let(:post) { create(:post) }
      let(:feedback) { Feedback.new }
      context 'when params missing' do
        %i[comment owner_id post_id].each do |key|
          before do
            params.delete(key)
          end
          it 'should not save post to database' do
            res = form.submit
            expect(res).to eq(false)
            expect(Feedback.count).to eq(0)
          end
        end
      end

      context 'when same owner feedbacks twice' do
        it 'should not save feedback to database twice' do
          res = form.submit
          expect(res).to eq(true)

          res2 = FeedbackForm.new(Feedback.new, params).submit
          expect(res2).to eq(false)
          expect(Feedback.count).to eq(1)
        end
      end

      context 'when user_id does not exist' do
        let(:params) { { comment: 'comment', owner_id: 12, user_id: 'not_exist' } }
        it 'should not save post to database' do
          res = form.submit
          expect(res).to eq(false)
          expect(Feedback.count).to eq(0)
        end
      end

      context 'when post_id does not exist' do
        let(:params) { { comment: 'comment', owner_id: 12, post_id: 'not_exist' } }
        it 'should not save post to database' do
          res = form.submit
          expect(res).to eq(false)
          expect(Feedback.count).to eq(0)
        end
      end
    end
  end
end
