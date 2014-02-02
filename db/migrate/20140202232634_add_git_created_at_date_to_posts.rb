class AddGitCreatedAtDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :git_created_at, :string
  end
end
