class WelcomeController < ApplicationController
  require 'json'

  def index
    @user = User.find(session[:id])
    @trees = Tree.all
  end
end
