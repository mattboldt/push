class RenameGithubUrlToGitUrl < ActiveRecord::Migration
  def change
    rename_column :posts, :github_url, :git_url
  end
end
