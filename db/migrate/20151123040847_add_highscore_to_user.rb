class AddHighscoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :high_score, :integer, :default => 0
  end
end
