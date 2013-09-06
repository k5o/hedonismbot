class CreateShowsTable < ActiveRecord::Migration
  def change
    create_table :shows do |c|
      c.string :title
      c.string :banner
      c.string :status
      c.string :latest_episode
      c.string :next_episode
      c.timestamps
    end
  end
end
