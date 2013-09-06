class TrackingsController < ApplicationController
  def create
    @title = params[:show_title].titleize

    if Tracking.show_available?(@title)
      @show = Show.find_or_initialize_by_title(@title)

      Show.create_show_data(@title) if @show.new_record?

      Tracking.create(:user_id => current_user.id, :show_id => Show.find_by_title(@title).id)
      
      # render partial
  end
end