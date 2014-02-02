module PostsHelper
  require 'redcarpet'
  # make sure the current post belongs to the current user!
  def require_permission
    post = Post.find_by_slug(params[:id])
    if current_user.id != post.user_id
      redirect_to user_post_path(post.user, post), notice: "Why are you trying to edit something that isn't yours? ಠ_ಠ"
    end
  end

  def is_owner?
    post = Post.find_by_slug(params[:id])
    current_user.id == post.user_id
  end

  # render markdown from github file
  def render_markdown(file)
    renderer = PygmentizeHTML
    extensions = {:autolink => true, :hard_wrap => true, :space_after_headers => true, :highlight => true, :tables => true, :fenced_code_blocks => true, :gh_blockcode => true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    @file = redcarpet.render file
  end
end
