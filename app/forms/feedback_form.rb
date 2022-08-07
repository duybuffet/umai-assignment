require_relative 'application_form'

class FeedbackForm < ApplicationForm
  attr_accessor :feedback, :params
  validate :check_valid_params
  validate :check_valid_feedback

  def initialize(feedback, params = {})
    @feedback = feedback
    @params = params
    assign_feedback_attributes
  end

  def submit
    return false if invalid?

    feedback.save
  end

  private

  def check_valid_feedback
    errors.add(:feedback, :invalid) if feedback.invalid?
  end

  def check_valid_params
    if params[:post_id].blank? && params[:user_id].blank?
      errors.add(:params, :required_post_id_or_user_id) 
    elsif params[:post_id].present?
      errors.add(:params, :post_id_not_existed) unless Post.exists?(params[:post_id])
    elsif params[:user_id].present?
      errors.add(:params, :user_id_not_existed) unless User.exists?(params[:user_id])
    end
  end

  def assign_feedback_attributes
    feedbackable_params = if params[:user_id].present?
                            { feedbackable_type: 'User', feedbackable_id: params[:user_id] }
                          elsif params[:post_id].present?
                            { feedbackable_type: 'Post', feedbackable_id: params[:post_id] }
                          end
    feedbackable_params ||= {}
    feedback.assign_attributes(params.slice(:comment, :owner_id).merge(feedbackable_params))
  end
end
