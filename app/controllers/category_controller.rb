class CategoryController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @flare                 = Category.find_by(name: "flare")
    @programming_languages = Category.find_by(name: "Programming Languages")
    flare_tree = @flare.get_tree_sub_cats
    programming_languages_tree = @programming_languages.get_tree_sub_cats
    render json: {flareTreeArray: flare_tree.to_json, programmingLanguagesTreeArray: programming_languages_tree.to_json }
  end

  def create
    @new_category = Category.new(params.require(:category).permit(:name))
    @parent_category = false
    if(params[:parent_id])
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

    render json: {id: "#{@new_category.id}"}#, status: 204
  end


end
