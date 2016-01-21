class AddChannelsToUser < ActiveRecord::Migration
  def change
    add_column :users, :channels, :text, array:true, default: []
  end
end
