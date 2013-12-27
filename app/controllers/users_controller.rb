class UsersController < ApplicationController

  def index
  end
  def show
    @user = User.find(params[:id])
  end

  def posts
    @user = User.find(params[:user_id])
    @posts = @user.posts.all
  end

end
