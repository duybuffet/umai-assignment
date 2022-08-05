require_relative './base_controller'

class PostsController < BaseController
  def index
    respond <<~HTML
      Hello from Posts controller
    HTML
  end
end
