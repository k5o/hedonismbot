class RenameTrackingsTableColumns < ActiveRecord::Migration
  def change
    change_table :trackings do |t|
      t.rename :users_id, :user_id
      t.rename :shows_id, :show_id
    end
  end
end
