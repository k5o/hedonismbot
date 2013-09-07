class Tracking < ActiveRecord::Base
  belongs_to :user
  belongs_to :show

  attr_accessible :user_id, :show_id
end