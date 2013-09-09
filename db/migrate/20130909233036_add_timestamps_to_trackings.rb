class AddTimestampsToTrackings < ActiveRecord::Migration
  def change
    add_column :trackings, :created_at, :datetime
    add_column :trackings, :updated_at, :datetime
  end
end
