class AddGitRepoNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :git_repo_name, :string
  end
end
