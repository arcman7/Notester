class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
   @user = User.new(user_params)
    if @user.save
      set_current_user(@user)
      redirect_to 'show'
    else
      render 'users_create_path'
    end
  end
  private
  def user_params
      params.require(:user).permit(:username, :email, :password)
  end
  def set_current_user(user)
    session[:user_id] = user.id
    @current_user = user
  end
end
