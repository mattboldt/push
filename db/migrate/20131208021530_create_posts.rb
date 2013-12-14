class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.string :github_url
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
