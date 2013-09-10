class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(params[:user]) ? User.new(params[:user]) : User.new_guest

    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = "Signup error, check your e-mail and try again."
      redirect_to root_path
    end
  end

  def destroy
  end
end