class Show < ActiveRecord::Base
  has_many :trackings
  has_many :users, through: :trackings
  serialize :latest_episode, Hash
  serialize :next_episode, Hash
end