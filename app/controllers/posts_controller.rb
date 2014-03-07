class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 15)
    # @posts = Post.where(:user_id => params[:id]).first
  end

end