class User < ActiveRecord::Base
  has_many :trackings
  has_many :shows, through: :trackings
end