class Users::PostsController < ApplicationController
  include GithubHelper
  include PostsHelper
  require 'redcarpet'
  require 'open-uri'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :github_auth, only: [:new, :edit, :create, :update, :destroy]

  # GET /posts
  def index
    @user = User.find_by_username(params[:user_id])
    @posts = @user.posts.all
  end

  # GET /posts/1
  def show
    file = open(@post.git_url) { |f| f.read }
    @file = render_markdown(file)
  end


  # GET /posts/new
  def new
    @user = current_user
    @post = @user.posts.new
  end

  # GET /posts/1/edit
  def edit
    @user = current_user
    if is_owner?
      file = open(@post.git_url) { |f| f.read }
      @file = file
    else
      redirect_to post_path(@user, @post), notice: 'This post does not belong to you!'
    end
  end

  # POST /posts
  def create
    @post = current_user.posts.new(post_params)
    commit_to_github(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path(@user, @post), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    if is_owner?
      commit_to_github(post_params)
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to posts_path(@user, @post), notice: 'Post was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @post, notice: 'This post does not belong to you!'
    end
  end

  # DELETE /posts/1
  def destroy
    if is_owner?
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end
    else
      redirect_to @post, notice: 'This post does not belong to you!'
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = User.find_by_username(params[:user_id]).posts.find(params[:id])
    end

    # strong params
    def post_params
      params.require(:post).permit(:title, :desc, :slug, :github_url, :user_id, :body, :git_file_name, :git_commit_message)
    end


end
