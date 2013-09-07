class TrackingsController < ApplicationController
  before_filter :load_imperatives

  def create
    @title = params[:show_title]

    if Show.show_available?(@title)
      @canonical_title = Show.show_available?(@title)
      @show            = Show.find_or_initialize_by_title(@canonical_title)

      Show.create_show_data(@canonical_title, @show.id) if @show.new_record?
      Tracking.create(:user_id => @user.id, :show_id => @show.id)
      
      render 'static_pages/index'
    else
      flash.now[:notice] = "Show not found!"

      render 'static_pages/index'
    end
  end

  private

  def load_imperatives
    # Creates a guest user
    current_user ? @user = User.find(current_user.id) : @user = User.new_guest
    @user.save
    puts @user.id
    puts "%" * 100
    debugger
    session[:user_id] = @user.id
 
    @shows = @user.shows

    @demo_shows = [Show.find_by_title("Game of Thrones"), 
    Show.find_by_title("Futurama"),
    Show.find_by_title("Adventure Time"),
    Show.find_by_title("Parks and Recreation"),
    Show.find_by_title("Suits"),
    Show.find_by_title("Top Gear")]
  end
end