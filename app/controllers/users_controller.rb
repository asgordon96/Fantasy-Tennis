class UsersController < ApplicationController
  def new
  end

  def create
    new_user = User.new(user_params)
    begin
      new_user.save!
    rescue => error
      message = error.message
      flash[:"alert-error"] = message
      redirect_to new_user_path
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
