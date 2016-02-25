class ResourceController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @resources = Resource.all
    render json: {resources: @resources}
  end

  def create
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file) )
    if params[:username]
      @user = User.find_by(username: params[:username])
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
    @resource = Resource.find_by(title: params[:id]) #better to use resource names rather than id for now
     if @resource
        render json: { description: @resource.description, children: @resource.children}
     else
        render json: {error: "resource not found"}
     end
  end#show

  def get_user_tree
    @user = User.find_by(username: params[:username])
    if(params[:resource]) #:resource => should be the resource name
      @tree = @user.trees.find_by(title: params[:resource])

    else
      @tree = @user.trees.order("created_at").first
    end
    render json: {tree: @tree.get_tree_resources}
  end

  def update
    if Resouce.exists? params[:id]
      @resource = resource.find(params[:id])
      @resource.update(params.require(:resource).permit(:description, :title, :parent))
      render json: {success: "update complete"}
    end
    render json: {error: "resource not found"}
  end#update
end
