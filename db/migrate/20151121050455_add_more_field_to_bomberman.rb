class AddMoreFieldToBomberman < ActiveRecord::Migration
  def change
    add_column :bombermen, :game_name, :string
    add_column :bombermen, :channel_name, :string
  end
end
