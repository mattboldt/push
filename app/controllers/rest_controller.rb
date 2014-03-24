class RestController < ApplicationController
  respond_to :json

  def git_repo_setup
    repo = params[:repo]
    # create new repo
    render json: Github.new.create_github_repo(current_user, repo)
  end
end
