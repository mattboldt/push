class PostsController < ApplicationController
  require 'redcarpet'
  require 'octokit'
  require 'open-uri'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_file, only: [:show, :edit]
  before_action :github_auth

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render_markdown(@file)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    create_github_repo_file
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
    update_github_repo_file
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
      params.require(:post).permit(:title, :slug, :github_url, :user_id, :body, :git_file_name, :git_commit_message)
    end

    # get file contents
    def load_file
      @file = open(@post.github_url) { |f| f.read }
    end

    # GitHub Repo Connectivity
    def github_auth
      token = current_user.authentications.find(:first, :conditions => { :provider => 'github' }).token
      @github = Octokit::Client.new(:access_token => token)
      @username = current_user.authentications.find(:first, :conditions => { :provider => 'github' }).username
      @repo = @username + '/blogtest'
      @ref = 'heads/master'
      @sha_latest_commit = @github.ref(@repo, @ref).object.sha
      @sha_base_tree = @github.commit(@repo, @sha_latest_commit).commit.tree.sha
    end

    # create a file on github
    def create_github_repo_file
      file_name = @post["git_file_name"].to_s
      blob_sha = @github.create_blob(@repo, Base64.encode64(@post["body"]), "base64")
      sha_new_tree = @github.create_tree(@repo,
                                [ { :path => file_name,
                                     :mode => "100644",
                                     :type => "blob",
                                     :sha => blob_sha } ],
                                 {:base_tree => @sha_base_tree }).sha
      commit_message = @post["commit_message"] || "New commit."
      sha_new_commit = @github.create_commit(@repo, commit_message, sha_new_tree, @sha_latest_commit).sha
      updated_ref = @github.update_ref(@repo, @ref, sha_new_commit)
      puts updated_ref
    end

    # update a file on github
    def update_github_repo_file
      file_name = @post["git_file_name"]
      blob_sha = @github.create_blob(@repo, Base64.encode64(@post["body"]), "base64")
      sha_new_tree = @github.create_tree(@repo,
                                [ { :path => file_name,
                                     :mode => "100644",
                                     :type => "blob",
                                     :sha => blob_sha } ],
                                 {:base_tree => @sha_base_tree }).sha
      commit_message = @post["commit_message"] || "New commit."
      sha_new_commit = @github.create_commit(@repo, commit_message, sha_new_tree, @sha_latest_commit).sha
      updated_ref = @github.update_ref(@repo, @ref, sha_new_commit)
      puts updated_ref
    end
  end