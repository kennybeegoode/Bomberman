class AddMapSelectionToBomberman < ActiveRecord::Migration
  def change
    add_column :bombermen, :selected_map, :integer, :default => 0
  end
end
