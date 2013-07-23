class SessionsController < ApplicationController
  def signin
  end
  
  def create
    # authenticate the user
    user = User.find_by(:email => params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      redirect_to sessions_signin_path
      flash[:"alert-error"] = "Invalid username or password"
    end

  end
  
  def signout
    session[:user_id] = nil
    redirect_to '/'
  end
end
