class ResourceController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @resources = Resource.all
    render json: {resources: @resources}
  end

  def create #handles creation and updates
    #@resouce = Resource.find_by(title: params[:resource][:title])
    # if @resouce
    #   @resource.update(params.require(:resource).permit(:description, :title))
    #   render json: {success: "update complete"}
    # end
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file) )
    # user should already be in the params hash, but parent is optional
    if params[:username]
      @user = User.find_by(username: params[:username])
    end

    if params[:parent]
      @parent = Resource.find_by(title: params[:parent])
    end
    if @user
        begin
          @new_resource.save
          if @user
            @user.resources << @new_resource
          end
          if @parent
            @parent.children << @new_resource

          end
          p '@'*90
          render json: {success: "save complete", id: @new_resource.id}#nothing: true, status: 204
        rescue ActiveRecord::RecordInvalid => e
           p 'E'*90
          render json: {error: e.record.errors.details}#, status: 400
        end
    else
      render json: {error: "could not find user"}
    end
  end#create

  def show
    #@resource = Resource.find_by(title: params[:id]) #better to use resource names rather than id for now
    @resource = Reousrce.find( params[:id] )
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
    #@resource = Resource.find_by(name: params[:id])
    @resource = Resource.find( params[:id] )
    if @resource
      @resource.update(params.require(:resource).permit(:description, :title, :parent))
      render json: {success: "update complete"}
    else
      render json: {error: "resource not found"}
    end
  end#update

  def update_parent
    #@resource = Resouce.find_by(title: params[:id])
    @resource = Resource.find( params[:id] )
    #@parent   = Resouce.find_by(title: params[:parent])
    @parent = Resource.find( params[:parent] )
    if @resource && @parent
      @old_parent = @resource.parent
      @old_parent.children.delete(@resource)
      @parent.children << @resource
      render json: {update: "successful"}#, :status => 200
    else
      render json: {error: "update was not successful"}
    end
  end
end
