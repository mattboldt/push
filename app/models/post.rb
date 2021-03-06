# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  slug               :string(255)
#  git_raw_url        :string(255)
#  user_id            :integer
#  body               :text
#  created_at         :datetime
#  updated_at         :datetime
#  git_file_name      :string(255)
#  git_commit_message :string(255)
#  desc               :string(255)
#  git_url            :string(255)
#  git_created_at     :string(255)
#

class Post < ActiveRecord::Base


  # before_update :save_update_to_github
  before_save :save_github_api_response
  before_create :format_post

  # before_save :authenticate_user!
  belongs_to :user
  validates :user_id, presence: true

  validates :title, presence: true
  validates :desc, presence: true

  validates :slug, uniqueness: true


  def to_param
    slug
  end

  def to_slug(ret)

    ret = ret.to_s
    #strip the string
    ret = ret.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'

    #convert double underscores to single
    ret.gsub! /-+/,"-"

    #strip off leading/trailing underscore
    ret.gsub! /\A[-\.]+|[-\.]+\z/,""

    ret.downcase!

    ret
  end

  def format_post
    self.slug = Time.now.strftime("%Y-%m-%d-") + to_slug(self.title)
  end

  def save_github_api_response
    self.git_url = "#{self.git_url}"+"#{self.git_file_name}"
    self.git_raw_url = "#{self.git_raw_url}"+"#{self.git_file_name}"
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
  require 'pygments'
  def block_code(code, language)
    Pygments.highlight(code, lexer: language, options: {lineanchors: 'line'})
  end
end
