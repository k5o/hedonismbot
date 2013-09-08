class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(params[:user]) ? User.new(params[:user]) : User.new_guest

    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      session[:user_id] = @user.id
      flash[:notice] = "Signed up!"
      redirect_to root_url
    else
      flash[:alert] = "Something went wrong, please try again."
      redirect_to root_url
    end
  end

  def destroy
  end
end