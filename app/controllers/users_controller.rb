class UsersController < ApplicationController
  def show
  end

  def posts
    @user = User.find(params[:user_id])
    @posts = @user.posts.all
  end

end
