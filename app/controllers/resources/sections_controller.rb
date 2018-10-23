module Resources
  class SectionsController < ApplicationController
    before_action :set_resource, only: %i[index edit update import new create destroy]
    before_action :set_section, only: %i[show edit update destroy]
  
    def index
    	@sections = @resource.sections
    end
  
    def import
    end
  
    def show; end
  
    def new
      @section = Section.new
    end
  
    def edit; end
  
    def create
      @section = @resource.sections.build(section_params)
      if @section.save
        redirect_to [@resource, Section], notice: 'Section was successfully created.'
      else
        render :new
      end
    end
  
    def update
      if @section.update(section_params)
        redirect_to [@resource, :sections], notice: 'Section was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @section.destroy
      redirect_to [@resource, :sections], notice: 'Section deleted'
    end
  
    def set_resource
      @resource = Resource.find(params[:resource_id])
    end

    def set_section
      @section = Section.find(params[:id])
    end
  
    def section_params
      params.fetch(:section, {}).permit(:name, :resource_id)
    end
  end
end
