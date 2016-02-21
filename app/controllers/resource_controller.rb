class ResourceController < ApplicationController
  def index

  end

  def create
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file)
    if(params[:user])
      @user = User.find(params[:user])
    end
    begin
      @new_resource.save
      @user.resources << @new_resource
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}, status: 400
    end
    render nothing: true, status: 204
  end


end
