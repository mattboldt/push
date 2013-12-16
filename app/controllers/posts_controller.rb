class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = Post.order("created_at DESC")
  end

end