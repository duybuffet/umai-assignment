require_relative 'application_form'

class PostForm < ApplicationForm
  attr_accessor :post, :params
  validate :check_valid_post

  def initialize(post, params = {})
    @post = post
    @params = params
    assign_post_attributes
  end

  def submit
    return false if invalid?

    post.save
  end

  private

  def check_valid_post
    errors.add(:post, :invalid) if post.invalid?
  end

  def assign_post_attributes
    author = User.find_or_initialize_by(login: params[:login])
    post.assign_attributes(params.slice(:title, :content, :author_ip))
    post.author = author if author.valid?
  end
end
