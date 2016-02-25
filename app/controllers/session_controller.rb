class SessionController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.find_by(email: params[:email])
    if @user.email && @user.authenticate(params[:password])
      set_current_user(@user)
      #redirect_to root_path
      render json: {username: @user.username}
    else
      render '/session/new'
    end
  end
  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path
  end
    private
  def set_current_user(user)
    session[:user_id] = user.id
    @current_user = user
  end
end
