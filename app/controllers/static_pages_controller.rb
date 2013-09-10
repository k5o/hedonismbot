class StaticPagesController < ApplicationController
  def index
    current_user ? @user = User.find(current_user.id) : @user = User.new

    @trackings = @user.trackings.includes(:show)

    @demo_shows = [Show.find_by_title("Game of Thrones"), 
      Show.find_by_title("Futurama"),
      Show.find_by_title("Adventure Time"),
      Show.find_by_title("Parks and Recreation"),
      Show.find_by_title("Cosmos: A Space-Time Odyssey"),
      Show.find_by_title("Top Gear")]
  end
end