class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = Post.all
    # @posts = Post.where(:user_id => params[:id]).first
  end

end