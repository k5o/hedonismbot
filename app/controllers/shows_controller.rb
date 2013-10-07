class ShowsController < ApplicationController
  def resurrect
    @show = Show.find(params[:id])

    puts @show.resurrect
    flash[:error] = "Sorry, show still appears to be canceled or still in hiatus :(" if @show.resurrect == false

    redirect_to root_path
  end
end