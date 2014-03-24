class AuthenticationsController < ApplicationController
  include GithubHelper
  def index
  end

  def new
    @authentication = Authentication.new
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    # If the user & authentication exists, update their info
    if authentication
      authentication.update_attributes(
        :username => omniauth['info']['nickname'],
        :email => omniauth['info']['email'],
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
        :email => omniauth['info']['email'],
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :token => omniauth['credentials']['token']
      )
    else
      user = User.new
      user.apply_omniauth(omniauth)
      user.username = omniauth['info']['nickname']
      user.email = omniauth['info']['email']
      if user.save
        flash[:notice] = "User created successfully."
        sign_in(:user, user)
        user.authentications.create!(
          :username => omniauth['info']['nickname'],
          :email => omniauth['info']['email'],
          :provider => omniauth['provider'],
          :uid => omniauth['uid'],
          :token => omniauth['credentials']['token']
        )
        redirect_to setup_path
      else
        flash[:notice] = "There was an error creating your account :("
        session[:omniauth] = omniauth.except('extra')
        redirect_to root_path
      end
    end
  end


  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  def failure
    flash[:notice] = "There was an error authenticaing with GitHub :("
    redirect_to root_path
  end

  # private
  #   def authentication_params
  #       params.require(:authentication).permit(:user_id, :provider, :uid)
  #   end
end
