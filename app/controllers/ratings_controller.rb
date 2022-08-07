require_relative './base_controller'

class RatingsController < BaseController
  def create
    rating = Rating.new(rating_params)

    if rating.save
      render_resource(rating.post)
    else
      render_errors(rating.errors)
    end
  end

  private

  def rating_params
    params.slice(:post_id, :rate)
  end
end
