class UserController < ApplicationController
  require 'json'
  def index
    @users = User.all
    render json: {users: @users}
  end
  def show
    @user = User.find(params[:id])
    render json: {user: @user}
  end

  def new
    @user = User.new
  end

  def create
   @user = User.new(user_params)
    if @user.save
      set_current_user(@user)
      redirect_to 'show'
    else
      render 'new_user_path'
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
