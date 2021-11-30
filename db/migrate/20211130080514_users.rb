class Users < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :reset_degest
  end
end
