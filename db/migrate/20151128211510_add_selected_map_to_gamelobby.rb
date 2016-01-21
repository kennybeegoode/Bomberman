class AddSelectedMapToGamelobby < ActiveRecord::Migration
  def change
    add_column :gamelobbies, :selected_map, :integer, :default => 0
  end
end
