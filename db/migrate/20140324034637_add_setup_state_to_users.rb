class AddSetupStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :setup, :boolean, default: false
  end
end
