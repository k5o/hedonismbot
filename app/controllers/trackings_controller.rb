class TrackingsController < ApplicationController
  def create
    current_user ? @user = User.find(current_user.id) : @user = User.new
    
    @title = params[:show_title].titleize

    if Tracking.show_available?(@title)
      canonical_title = Tracking.show_available(@title)

      @show = Show.find_or_initialize_by_title(canonical_title)

      Show.create_show_data(canonical_title, @show.id) if @show.new_record?

      Tracking.create(:user_id => @user.id, :show_id => @show.id)
      
      # render partial
  end
end