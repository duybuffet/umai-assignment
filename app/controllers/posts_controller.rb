require_relative './base_controller'

class PostsController < BaseController
  def index
  end

  def create
    form = PostForm.new(Post.new, post_params)

    if form.submit
      render_resource(form.post)
    else
      render_errors(form.errors)
    end
  end

  private

  def post_params
    params.slice(:title, :content, :login, :author_ip)
  end
end
