class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      current_user = @user.id
      flash[:notice] = "Signed up!"
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
  end
end