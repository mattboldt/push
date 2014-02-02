class AuthenticationsController < ApplicationController
  include GithubHelper
  # before_action :authenticate_user!
  def index
    @authentications = current_user.authentications if current_user
  end

  def new
    @authentication = Authentication.new
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.update_attributes(
        :username => omniauth['info']['nickname'],
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :token => omniauth['credentials']['token']
      )
      flash[:notice] = "Signed in successfully."
      sign_in(:user, authentication.user)
      redirect_to current_user
    elsif current_user
      current_user.authentications.create!(
        :username => omniauth['info']['nickname'],
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :token => omniauth['credentials']['token']
      )

      # create new repo
      if Github.new.create_github_repo(current_user)
        flash[:notice] = "Repo created."
        redirect_to user_posts_path
      else
        flash[:notice] = "Couldn't create repo."
        redirect_to user_posts_path
      end

    else
      user = User.new
      user.apply_omniauth(omniauth)
      user.username = omniauth['info']['nickname']
      if user.save
        # create new repo
        Github.new.create_github_repo(user)
        flash[:notice] = "User created in successfully."
        sign_in(:user, user)
        redirect_to user_posts_path(user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
    # raise omniauth.to_yaml
  end

  # def create_from_github
  #   omniauth = request.env["omniauth.auth"]
  #   @user = User.find_by_github_uid(omniauth["uid"]) || User.create_from_omniauth(omniauth)
  #   # Hook into your own authentication system!
  #   sign_in @user
  #   # This would normally be configured to return to the previous path
  #   redirect root_path, :notice => "Welcome, #{@user.name}"
  # end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  def failure
    omniauth = request.env["omniauth.auth"]
    @user = User.find_by_github_uid(omniauth["uid"]) || User.create_from_omniauth(omniauth)
    # Hook into your own authentication system!
    sign_in @user
    # This would normally be configured to return to the previous path
    redirect root_path, :notice => "Welcome, #{@user.name}"
  end

  # private
  #   def authentication_params
  #       params.require(:authentication).permit(:user_id, :provider, :uid)
  #   end
end
