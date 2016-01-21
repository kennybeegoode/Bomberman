class AddDefaultImageUrlForUser < ActiveRecord::Migration
  def change
    change_column :users, :image, :string, :default => "/assets/img_thumbnail_0.png"
  end
end
