require_relative './base_controller'

class PostsController < BaseController
  def index
    respond_json({ test: '123' })
  end
end
