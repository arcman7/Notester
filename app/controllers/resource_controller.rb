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

    if params[:parent] && @user
      @parent = @user.resources.find_by(title: params[:parent])
      if !@parent
        @parent = Resource.create(title: params[:parent]) ####################### left off here3
      end
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
          #p '@'*90
          #p @new_resource,@parent
          if @parent
            render json: {success: "save complete", id: @new_resource.id, parent_id: @parent.id}#nothing: true, status: 204
          else
            render json: {success: "save complete", id: @new_resource.id}
          end
        rescue ActiveRecord::RecordInvalid => e
           #p 'E'*90
          render json: {error: e.record.errors.details}#, status: 400
        end
    else
      render json: {error: "could not find user"}
    end
  end#create

  def show
    #@resource = Resource.find_by(title: params[:id]) #better to use resource names rather than id for now
    @resource = Resource.find( params[:id] )
     if @resource
        render json: { description: @resource.description, children: @resource.children, id: @resource.id, parent: @resource.parents.first }
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
    #the update route/method takes two paremeters; resource.id and new-parent.id
    # it attempts to find the old parent on the provided resource if there is one
    # deletes the the child-parent relationships
    # attempts to find the new-parent... how?? parent id's only exist as the previously saved parent.id

    #new convention will be defined here...
    # updates will come with the parent defined by name, and looked up as a resource of the subset belonging to the user
    logged_in = false

    if params[:username]
        @user = User.find(session[:user_id])
        if @user.username == params[:username]
            logged_in = true
        end
    end

    if logged_in
        if params[:id]
            @resource = Resource.find( params[:id] )
        end
        if @resource
            #update parents children to remove child
            @old_parent = @resource.parents.first

            if @old_parent
                if @old_parent.title != params[:parent_title]
                    @old_parent.children.delete(@resource)
                end
            end

            @resource.update(params.require(:resource).permit(:description, :title))

            if params[:parent_title]
                @parent = @user.resources.find_by( title: params[:parent_title] )
            end
            if @parent
                @parent.children << @resource
                render json: {success: "update complete", id: @resource.id, parent_id: @parent.id }
                #Do you even lyft

            else#creating parent if it doenst exist yet
                @parent = @user.resources.create(title: params[:parent_title])
                if @parent
                  @parent.children << @resource
                  render json: {success: "update complete", id: @resource.id, parent_id: @parent.id }
                else
                  render json: {error: "failed to create parent subject"}
                end
                #render json: {error: "parent-resource not found",  code: 3}
            end
        else
            render json: {error: "resource not found", code: 2}
        end
    else
        #p session[:user_id]
        #p User.find(session[:user_id])
        render json: {error: "user not logged in or not found", code: 1}
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

  def show_by_name
     @resource = Resource.find_by(title: params[:id]) #better to use resource names rather than id for now
     if @resource
        render json: { description: @resource.description, children: @resource.children, id: @resource.id, parent: @resource.parents.first }
     else
        render json: {error: "resource not found"}
     end
  end#show_by_name
end
