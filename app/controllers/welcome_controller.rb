class WelcomeController < ApplicationController
  require 'json'

  def index
    if session[:id]
      @user = User.find(session[:id])
    end
    @trees = Tree.all
  end
end
