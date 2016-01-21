class CreateBombermen < ActiveRecord::Migration
  def change
    create_table :bombermen do |t|
      t.text :lobbyid

      t.timestamps null: false
    end
  end
end
