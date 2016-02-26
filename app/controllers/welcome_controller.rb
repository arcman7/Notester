class WelcomeController < ApplicationController
  require 'json'

  def index
    if session[:id]
      @user = User.find(session[:id])
    end
    p "trees:"
    @trees = Tree.all
    p @trees.first.category.name
  end
end
