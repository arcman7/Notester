class WelcomeController < ApplicationController
  def index
    ran = [*1..Category.all.length].sample
    @cat = Category.find(ran)
    @note = Resource.first
  end
end
