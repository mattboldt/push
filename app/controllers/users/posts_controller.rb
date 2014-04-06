class Users::PostsController < ApplicationController
  # include GithubHelper
  include PostsHelper
  require 'redcarpet'
  require 'open-uri'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :show]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]
  before_action :github_auth, only: [:new, :edit, :create, :update, :destroy]

  # GET /posts
  def index
    @posts = @user.posts.all
  end

  # GET /posts/1
  def show
    if @post
      @body = render_markdown(@post.body)
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
    render layout: 'editor'
  end

  # GET /posts/1/edit
  def edit
    render layout: 'editor'
    @user = current_user
      # file = open(@post.git_url) { |f| f.read }
      # @file = file
  end

  # Update from GitHub
  def pull
    render json: Github.new.pull_from_github(params)
  end

  # POST /posts
  def create
    commit_params = {
      :git_created_at => Time.now.strftime("%Y/%m/%d/"),
      :git_file_name => Time.now.strftime("%Y/%m/%d/") + Post.new.to_slug(post_params["title"]) + ".md"
    }
    final_params = post_params.merge(commit_params)
    @post = current_user.posts.new(final_params)
    respond_to do |format|
      if @post.save
        commit = Github.new.commit_to_github(final_params)
        if commit
          format.html { redirect_to user_post_path(current_user, @post), notice: 'Post was successfully created.' }
          format.json { render action: 'show', status: :created, location: @post }
        else
          format.html { render action: 'new' }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    commit_params = {
      :git_created_at => @post.git_created_at,
      :git_file_name => @post.git_file_name
    }
    final_params = post_params.merge(commit_params)
    respond_to do |format|
      if @post.update_attributes(post_params)
        commit = Github.new.commit_to_github(final_params)
        if commit
          format.html { redirect_to user_post_path(current_user, @post), notice: 'Post was successfully updated.' }
          format.json { render json: @post }
        else
          format.html { render action: 'edit' }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  def preview
    require 'redcarpet'
    preview = params[:post][:body]
    # renderer = Redcarpet::Render::HTML.new(:filter_html => true, :hard_wrap => true, :autolink => true)
    renderer = PygmentizeHTML
    extensions = {:autolink => true, :hard_wrap => true, :space_after_headers => true, :highlight => true, :tables => true, :fenced_code_blocks => true, :gh_blockcode => true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    @preview = redcarpet.render preview
    # respond_to do |format|
    #   format.json { render @preview }
    #   format.html { render @preview }
    #   format.js { render @preview }
    # end
    respond_to do |format|
      format.html { render :text => @preview }
    end
  end



  private

    def set_user
      @user = User.find_by_username(params[:user_id])
    end

    def set_post
      @post = User.find_by_username(params[:user_id]).posts.find_by_slug(params[:id])
      if !@post
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Post not found :(' }
          format.json { render json: '@post.errors', status: :unprocessable_entity }
        end
      end
    end

    # strong params
    def post_params
      params.require(:post).permit(:title, :desc, :slug, :git_url, :git_raw_url, :user_id, :body, :git_file_name, :git_commit_message, :git_created_at, :git_repo_name)
    end

    # GitHub Repo Connectivity
    def github_auth
      Github.new.github_auth(current_user)
    end


end
