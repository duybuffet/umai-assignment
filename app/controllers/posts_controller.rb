require_relative './base_controller'

class PostsController < BaseController
  def index
    return top_average_rating if params[:top_average_rating].present?

    render_resources(Post.all, params)
  end

  def create
    form = PostForm.new(Post.new, post_params)

    if form.submit
      render_resource(form.post)
    else
      render_errors(form.errors)
    end
  end

  def ip_where_authors_posted
    render_resources(Post.group_by_author_ip, params, { each_serializer: IpWhereAuthorsPostedSerializer })
  end

  private

  def post_params
    params.slice(:title, :content, :login, :author_ip)
  end

  def top_average_rating
    render_resources(Post.by_average_rating, params, { each_serializer: PostAverageRatingSerializer })
  end
end
