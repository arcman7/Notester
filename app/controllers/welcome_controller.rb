class WelcomeController < ApplicationController
  require 'json'
  def index
    # USED FOR INDEX PLACEHOLDER/NEED A RANDOM USERS INFO
    ran = [*1..Category.all.length].sample
    @cat = Category.find(ran)
    @note = Resource.first
  end
end
