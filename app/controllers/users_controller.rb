class UsersController < ApplicationController
  def new
  end

  def create
    new_user = User.new(user_params)
    begin
      new_user.save!
      redirect_to user_path(new_user.id)
    rescue => error
      message = error.message
      flash[:"alert-error"] = message
      redirect_to new_user_path
    end
  end
  
  def show
    # show the user home
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end
  
  def update
  end

  def destroy
  end
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end
  
end
