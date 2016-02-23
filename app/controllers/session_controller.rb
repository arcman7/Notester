class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.find_by(email: params[:email])
    if @user.email && @user.authenticate(params[:password])
      set_current_user(@user)
      redirect_to root_path
    else
      render '/sessions/new'
    end
  end
  def destroy
    p session
    session.destroy
    redirect_to root_path
  end
    private
  def set_current_user(user)
    session[:user_id] = user.id
    @current_user = user
  end
end
