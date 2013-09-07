class StaticPagesController < ApplicationController
  def index
    if current_user
      @user = User.find(current_user.id)
    else
      @user = User.new
    end

    @shows = @user.shows

    @demo_shows = [Show.find_by_title("Game of Thrones"), 
      Show.find_by_title("Futurama"),
      Show.find_by_title("Adventure Time"),
      Show.find_by_title("Parks and Recreation"),
      Show.find_by_title("Suits"),
      Show.find_by_title("Top Gear")]
  end
end