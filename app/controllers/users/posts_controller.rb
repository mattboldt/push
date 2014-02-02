class Users::PostsController < ApplicationController
  # include GithubHelper
  include PostsHelper
  require 'redcarpet'
  require 'open-uri'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]
  before_action :github_auth, only: [:new, :edit, :create, :update, :destroy]

  # GET /posts
  def index
    @user = User.find_by_username(params[:user_id])
    @posts = @user.posts.all
  end

  # GET /posts/1
  def show
    # file = open(@post.git_url) { |f| f.read }
    # @file = render_markdown(file)
    @body = render_markdown(@post.body)
  end


  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
      # file = open(@post.git_url) { |f| f.read }
      # @file = file
  end

  # POST /posts
  def create
    commit = Github.new.commit_to_github(post_params)
    # commit_params = {
    #   :git_url => commit[:git_url]
    # }
    final_params = post_params.merge(commit_params)
    @post = current_user.posts.new(final_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to user_posts_path(current_user, @post), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        commit = Github.new.commit_to_github(post_params)
        if commit
          format.html { redirect_to user_post_path(current_user, @post), notice: 'Post was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = User.find_by_username(params[:user_id]).posts.find_by_slug(params[:id])
    end

    # strong params
    def post_params
      params.require(:post).permit(:title, :desc, :slug, :git_url, :git_raw_url, :user_id, :body, :git_file_name, :git_commit_message)
    end

    # GitHub Repo Connectivity
    def github_auth
      Github.new.github_auth(current_user)
    end


end
