require_relative './base_controller'

class FeedbacksController < BaseController
  def create
    feedback_form = FeedbackForm.new(Feedback.new, feedback_params)

    if feedback_form.submit
      render_resources(Feedback.from_owner(feedback_form.feedback.owner_id))
    else
      render_errors(feedback_form.errors)
    end
  end

  private

  def feedback_params
    params.slice(:user_id, :post_id, :comment, :owner_id)
  end
end
