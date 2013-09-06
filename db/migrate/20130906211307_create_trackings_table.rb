class CreateTrackingsTable < ActiveRecord::Migration
  def change
    create_table :trackings do |c|
      c.references :users
      c.references :shows
    end
  end
end
