require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  should have_many :users
  should have_many :trackings
end