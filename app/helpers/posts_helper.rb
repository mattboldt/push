module PostsHelper
  # make sure the current post belongs to the current user!
  def is_owner?
    post = Post.find(params[:id])
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
