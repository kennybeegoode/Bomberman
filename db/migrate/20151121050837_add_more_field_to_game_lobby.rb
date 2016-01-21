class AddMoreFieldToGameLobby < ActiveRecord::Migration
  def change
    add_column :gamelobbies, :bg_image, :string
  end
end
