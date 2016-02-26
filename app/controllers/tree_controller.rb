class TreeController < ApplicationController
  require 'json'
    skip_before_action :verify_authenticity_token

  def index
    render json: {trees: Tree.all}
  end

  def create
    if params[:category]
      @category = Category.find_by(name: params[:category])
      name = params[:category]
      if @category
        @tree = Tree.create(name: name)
        @category.tree = @tree
        render json: {tree: "tree creation success"}
      else
        render json: {error: "resource could not be found"}
      end
    else
      render json: {error: "category name missing from params/data"}
    end
  end#create
end