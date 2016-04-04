class CategoryController < ApplicationController
  require 'json'

  skip_before_action :verify_authenticity_token

  def index
    @flare = Category.find_by(name: "flare")
    #p '*'*90
    #@programming_languages = Category.find_by(name: "Programming Languages")
    flare_tree = @flare.get_tree_sub_cats

    #programming_languages_tree = @programming_languages.get_tree_sub_cats
    # render json: {flareTreeArray: flare_tree.to_json, programmingLanguagesTreeArray: programming_languages_tree.to_json }
    # render json: {flareTree: flare_tree.to_json, programmingLanguagesTree: programming_languages_tree.to_json }
    render json: {tree: flare_tree.to_json }
  end

  def create
    if !params[:category][:name]
      return "error: missing params; category[:name]"
    end

    @category = Category.find_by(name: params[:category][:name])
    if @category #check for pre-exsisting category(should happen once per browser because the id is not set)
      @new_category = @category
      @new_category.update(params.require(:category).permit(:description, :name))
    else
      @new_category = Category.new(params.require(:category).permit(:name, :description))
    end

    # @parent_category = false
    if params[:parent_id]
      @parent_category = Category.find(params[:parent_id])
    end

    begin
      @new_category.save
      if @parent_category
        @parent_category.sub_categories << @new_category
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}#, status: 400
    end

    render json: { success: "create and save complete", id: @new_category.id, parent_id: @parent_category.id }#, status: 204
  end#create

  def show_by_name
      if params[:id]
         @category = Category.find_by(name: params[:id]) #better to use resource names rather than id for now
         if @category
            render json: { category: { description: @category.description, children: @category.sub_categories, id: @category.id, name: @category.name, parent: @category.parent_category } }
         else
            render json: {error: "resource not found"}
         end
      else
         render json: {error: "no search params were given"}
      end
  end#show_by_name

  def show
    if params[:type] == 'name'
        show_by_name
    else
        @category = Category.find( params[:id] )

        if @category
          render json: { description: @category.description, children: @category.sub_categories, id: @category.id, parent: @category.parent_category }
        else
          render json: {error: "category not found"}
        end
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
      render json: {error: "category-name missing from params/data"}
    end
  end#tree

  def update
    @category = Category.find_by(name: params[:category][:name])
    if @category
      @category.update(params.require(:category).permit(:description, :name))
      if @category.parent_category
        parent_id = @category.parent_category.id
      else
        parent_id = nil
      end
      render json: {success: "update complete", id: @category.id, parent_id: parent_id}
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
      render json: {update: "successful", parent_id: @parent.id}#, :status => 200
    else
      render json: {error: "update was not successful"}
    end
  end#update_parent
end
