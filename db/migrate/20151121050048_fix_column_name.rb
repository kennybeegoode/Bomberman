class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :bombermen, :lobbyid, :lobby_id
    rename_column :bombermen, :users, :user_list

    rename_column :gamelobbies, :lobbyid, :lobby_id
    rename_column :gamelobbies, :lobbyname, :lobby_name
    rename_column :gamelobbies, :gamestarted, :game_started
    rename_column :gamelobbies, :usercount, :user_count
    rename_column :gamelobbies, :userlist, :user_list


  end
end
