class UserController < ApplicationController
  before_action :allow_cross_domain
  skip_before_action :verify_authenticity_token
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
    render "user/new.html.erb"
  end

  def create
   @user = User.create(user_params)

    if @user.save
      set_current_user(@user)
      render json: {username: @user.username}
    else
      if @user.errors.any? # If there are errors, do something
        render json: {errors: @user.errors}
      end
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
