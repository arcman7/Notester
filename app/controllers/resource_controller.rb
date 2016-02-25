class ResourceController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @resources = Resource.all
    render json: {resources: @resources}
  end

  def create
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file) )
    if params[:user_email]
      @user = User.find_by(email: params[:user_email])
    end

    begin
      @new_resource.save
      @user.resources << @new_resource
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}#, status: 400
    end
    render nothing: true, status: 204
  end

  def show
     if Resource.exists? params[:id]
        @resource = Resource.find(params[:id])
        render json: { resource: @resource, children: @resource.children }
     else
        render json: {error: "resource not found"}
     end
  end#show
    def update
    if Resouce.exists? params[:id]
      @resource = resource.find(params[:id])
      @resource.update(params.require(:resource).permit(:description, :title, :parent))
      render json: {success: "update complete"}
    end
    render json: {error: "resource not found"}
  end#update
end
