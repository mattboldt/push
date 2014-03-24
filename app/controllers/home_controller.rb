class HomeController < ApplicationController
  def index
    render layout: "home"
  end
  def setup
    authenticate_user!
  end
end
