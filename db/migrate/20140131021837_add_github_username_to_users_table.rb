class AddGithubUsernameToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :git_username, :string
  end
end
