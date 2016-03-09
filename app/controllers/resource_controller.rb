class ResourceController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @resources = Resource.all
    render json: {resources: @resources}
  end

  def create #handles creation and updates
    @resouce = Resource.find_by(title: params[:resource][:title])
    if @resouce
      @resource.update(params.require(:resource).permit(:description, :title))
      render json: {success: "update complete"}
    end
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file) )
    # user should already be in the params hash, but parent is optional
    if params[:username]
      @user = User.find_by(username: params[:username])
    end

    if params[:parent]
      @parent = Resource.find_by(title: params[:parent])
    end

    begin
      @new_resource.save
      if @user
        @user.resources << @new_resource
      end
      if @parent
        @parent.children << @new_resource
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}#, status: 400
    end
    render json: {success: "save complete"}#nothing: true, status: 204
  end

  def show
    @resource = Resource.find_by(title: params[:id]) #better to use resource names rather than id for now
     if @resource
        render json: { description: @resource.description, children: @resource.children, id: @resource.id}
     else
        render json: {error: "resource not found"}
     end
  end#show

  def get_user_tree
    begin
      @user = User.find_by(username: params[:username])
      if(params[:resource]) #:resource => should be the resource name
        @tree = @user.trees.find_by(title: params[:resource])
      else
        @tree = @user.trees.order("created_at").first
      end
    rescue
      render json: {error: "the user resource could not be found"}
    end

    render json: {tree: @tree.get_tree_resources}
  end

  def update
    @resource = resource.find_by(name: params[:id])

    if @resource
      @resource.update(params.require(:resource).permit(:description, :title, :parent))
      render json: {success: "update complete"}
    end
    render json: {error: "resource not found"}
  end#update

  def update_parent
    @resource = Resouce.find_by(title: params[:id])
    @parent   = Resouce.find_by(title: params[:parent])
    if @resource && @parent
      @old_parent = @resource.parent
      @old_parent.children.delete(@resource)
      @parent.children << @resource
    else
      render json: {error: "update was not successful"}
    end
    render json: {update: "successful"}#, :status => 200
  end
end
