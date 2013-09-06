class ChangeShowsTable < ActiveRecord::Migration
  def change
    remove_column :shows, :latest_episode
    remove_column :shows, :next_episode
    add_column :shows, :last_title, :string
    add_column :shows, :last_airdate, :date
    add_column :shows, :last_episode, :string
    add_column :shows, :next_title, :string
    add_column :shows, :next_airdate, :date
    add_column :shows, :next_episode, :string
    add_column :shows, :airtime, :string
  end
end