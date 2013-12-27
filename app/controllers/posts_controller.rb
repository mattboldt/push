class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = Post.find(:all, "ORDER BY created_at DESC")
    # @posts = Post.where(:user_id => params[:id]).first
  end

end