class HomeController < ApplicationController
  def index
    # show the Home Page
    if session[:user_id]
      redirect_to user_path(session[:user_id])
    end
  end
end
