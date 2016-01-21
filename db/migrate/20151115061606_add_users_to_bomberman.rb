class AddUsersToBomberman < ActiveRecord::Migration
  def change
    add_column :bombermen, :users, :text, :array => true, :default => []
  end
end
