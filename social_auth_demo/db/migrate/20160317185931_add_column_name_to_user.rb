class AddColumnNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, default: '',null: false
    add_column :users, :username, :string
  end
end
