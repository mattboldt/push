class Post < ActiveRecord::Base
  # before_update :save_update_to_github
  before_create :save_github_api_response

  # before_save :authenticate_user!
  belongs_to :user
  validates :user_id, presence: true


  private
    def save_github_api_response
      self.git_url = "https://raw.github.com/mattboldt/gitblog/master/#{self.git_file_name}"
    end
    def render_body
      require 'redcarpet'
      # renderer = Redcarpet::Render::HTML.new(:filter_html => true, :hard_wrap => true, :autolink => true)
      renderer = PygmentizeHTML
      extensions = {:autolink => true, :hard_wrap => true, :space_after_headers => true, :highlight => true, :tables => true, :fenced_code_blocks => true, :gh_blockcode => true}
      redcarpet = Redcarpet::Markdown.new(renderer, extensions)
      self.body = redcarpet.render self.body_input
      self.preview = redcarpet.render self.preview_input
    end

end


class PygmentizeHTML < Redcarpet::Render::HTML
  def block_code(code, language)
    require 'pygments'
    Pygments.highlight(code, lexer: language.to_sym, options: {lineanchors: 'line'})
  end
end
