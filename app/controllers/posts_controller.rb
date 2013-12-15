class PostsController < ApplicationController
  include GithubHelper
  require 'redcarpet'
  require 'open-uri'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  # before_action :load_file, only: [:show, :edit]
  before_action :github_auth, only: [:new, :edit, :create, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    file = open(@post.git_url) { |f| f.read }
    @file = render_markdown(file)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    file = open(@post.git_url) { |f| f.read }
    @file = file
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @post['user_id'] = current_user.id
    commit_to_github(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    # raise @post.to_yaml
    @post['user_id'] = current_user.id
    commit_to_github(post_params)
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  # render markdown from github file
  def render_markdown(file)
    renderer = PygmentizeHTML
    extensions = {:autolink => true, :hard_wrap => true, :space_after_headers => true, :highlight => true, :tables => true, :fenced_code_blocks => true, :gh_blockcode => true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    @file = redcarpet.render file
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # strong params
    def post_params
      params.require(:post).permit(:title, :slug, :desc, :git_url, :user_id, :body, :git_file_name, :git_commit_message)
    end

  end