class TrackingsController < ApplicationController
  before_filter :load_imperatives, except: [:destroy]

  def create
    @title = params[:show_title]
    @show = Show.find_by_title(@title.titleize)

    if @show
      @tracking = Tracking.create(:user_id => @user.id, :show_id => @show.id)
      render 'success'

    elsif Show.show_available?(@title)
      @canonical_title = Show.show_available?(@title)
      @show            = Show.find_or_initialize_by_title(@canonical_title)

      @show.save if @show.new_record?

      Show.create_show_data(@title, @canonical_title, @show.id) if @show.status.nil?

      @tracking = Tracking.create(:user_id => @user.id, :show_id => @show.id)

      if @tracking.valid?
        render 'success'
      else
        render 'error'
      end

    else
      render 'error'
    end
  end

  def destroy
    @id = params[:id]
    Tracking.find(@id).destroy
    render 'destroy_success'
  end

  private

  def load_imperatives
    # Creates a guest user
    current_user ? @user = User.find(current_user.id) : @user = User.new_guest

    if @user.guest?
      @user.save
      session[:user_id] = @user.id
    end

    @trackings = @user.trackings.includes(:shows)
  end
end