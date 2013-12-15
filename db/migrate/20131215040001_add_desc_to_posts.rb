class AddDescToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :desc, :string
  end
end
