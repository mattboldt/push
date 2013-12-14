class AddExtraFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :git_file_name, :string
    add_column :posts, :git_commit_message, :string
  end
end
