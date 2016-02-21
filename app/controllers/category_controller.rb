class CategoryController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

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
