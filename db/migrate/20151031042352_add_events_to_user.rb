class AddEventsToUser < ActiveRecord::Migration
  def change
    add_column :users, :events, :text, array:true, default: []
  end
end
