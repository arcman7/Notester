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
   @user = User.new(user_params)
    if @user.save
      set_current_user(@user)
      redirect_to root_path
    else
      render 'user/new'
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
