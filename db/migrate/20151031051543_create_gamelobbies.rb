class CreateGamelobbies < ActiveRecord::Migration
  def change
    create_table :gamelobbies do |t|
      t.text :lobbyid
      t.text :lobbyname
      t.boolean :public
      t.boolean :gamestarted
      t.integer :usercount
      t.text :userlist, array: true, default: []

      t.timestamps null: false
    end
  end
end
