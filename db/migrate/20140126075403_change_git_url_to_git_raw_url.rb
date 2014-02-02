class ChangeGitUrlToGitRawUrl < ActiveRecord::Migration
  def change
    # rename_column :posts, :git_url, :git_raw_url
    add_column :posts, :git_url, :string
  end
end
