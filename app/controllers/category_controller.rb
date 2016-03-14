class CategoryController < ApplicationController
  require 'json'
  require 'uri'

  skip_before_action :verify_authenticity_token

  def index
    @flare                 = Category.find_by(name: "flare")
    #@programming_languages = Category.find_by(name: "Programming Languages")
    flare_tree = @flare.get_tree_sub_cats
    #programming_languages_tree = @programming_languages.get_tree_sub_cats
    # render json: {flareTreeArray: flare_tree.to_json, programmingLanguagesTreeArray: programming_languages_tree.to_json }
    # render json: {flareTree: flare_tree.to_json, programmingLanguagesTree: programming_languages_tree.to_json }

    render json: {tree: flare_tree.to_json }
  end

  def create
    @new_category = Category.new(params.require(:category).permit(:name))
    @parent_category = false
    if params[:parent_id]
      @parent_category = Category.find(params[:parent_id])
    end

    begin
      @new_category.save
      if @parent_category
        @parent_category.sub_categories << @new_category
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}, status: 400
    end

    render json: {success: "create and save complete", id: @new_category.id}#, status: 204
  end

  def show
    @category = Category.find_by(name: params[:id])

    if @category
      render json: { description: @category.description, children: @category.sub_categories, id: @category.id }
    else
      render json: {error: "category not found"}
    end
  end #show

  def tree
    if params[:id]
      @category = Category.find_by(name: params[:id])
      if @category
        @tree = @category.get_tree_sub_cats.to_json
        #p @tree
        render json: {tree: @tree}
      else
        render json: {error: "category not found"}
      end
    else
      render json: {error: "category name missing from params/data"}
    end
  end

  def update
    @category = Category.find_by(name: params[:id])
    if @category
      @category.update(params.require(:category).permit(:description, :name))
      render json: {success: "update complete"}
    else
      render json: {error: "category not found"}
    end
  end#update

  def update_parent
    @category = Category.find(params[:id])
    #@parent   = Category.find_by(name: params[:parent])
    @parent   = Category.find( params[:parent] )

    if @category && @parent
      @old_parent = @category.parent_category
      @old_parent.sub_categories.delete(@category)
      @parent.sub_categories << @category
      render json: {update: "successful"}#, :status => 200
    else
      render json: {error: "update was not successful"}
    end
  end
end
