class CreateGamechats < ActiveRecord::Migration
  def change
    create_table :gamechats do |t|
      t.text :lobbyid
      t.text :message

      t.timestamps null: false
    end
  end
end
