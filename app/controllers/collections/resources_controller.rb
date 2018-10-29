module Collections
  class ResourcesController < ApplicationController
    before_action :set_collection, only: %i[index edit update import new create destroy]
    before_action :set_resource, only: %i[show edit update destroy]
  
    def index
    	@resources = @collection.resources.page params[:page]
    end

    def search
      @q = params[:q]
      @content_units = ContentUnit.search @q, page: params[:page], per_page: 20, highlight: true, includes: {section: {resource: :collection}}
    end
  
    def import
    end
  
    def show; end
  
    def new
      @resource = Resource.new
    end
  
    def edit; end
  
    def create
      @resource = @collection.resources.build(resource_params)
      if @resource.save
        redirect_to [@collection, Resource], notice: 'Resource was successfully created.'
      else
        render :new
      end
    end
  
    def update
      if @resource.update(resource_params)
        redirect_to [@collection, :resources], notice: 'Resource was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @resource.destroy
      redirect_to [@collection, :resources], notice: 'Resource deleted'
    end
  
    def set_collection
      @collection = Collection.find(params[:collection_id])
    end

    def set_resource
      @resource = Resource.find(params[:id])
    end
  
    def resource_params
      params.fetch(:resource, {}).permit(:name, :collection_id)
    end
  end
end
