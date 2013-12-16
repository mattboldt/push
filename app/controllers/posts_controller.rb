class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = Post.all
  end

end