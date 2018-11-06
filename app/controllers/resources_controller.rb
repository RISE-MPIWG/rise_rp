  class ResourcesController < ApplicationController
    before_action :set_resource, only: %i[show edit update destroy]
  
    def index
    	@resources = Resource.all.page params[:page]
    end

    def search
      @q = params[:q]
      @content_units = ContentUnit.search @q, page: params[:page], per_page: 20, highlight: true, includes: {section: {resource: :collection}}
    end
  
    def set_resource
      @resource = Resource.find(params[:id])
    end
  
    def resource_params
      params.fetch(:resource, {}).permit(:name, :collection_id)
    end
  end
