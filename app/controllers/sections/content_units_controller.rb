module Sections
  class ContentUnitsController < ApplicationController
    before_action :set_section, only: %i[index edit update import new create destroy]
    before_action :set_content_unit, only: %i[show edit update destroy]
  
    def index
    	@content_units = @section.content_units.page params['page']
    end
  
    def import
    end
  
    def show; end
  
    def new
      @content_unit = ContentUnit.new
    end
  
    def edit; end
  
    def create
      @content_unit = @section.content_units.build(content_unit_params)
      if @content_unit.save
        redirect_to [@section, ContentUnit], notice: 'Content Unit was successfully created.'
      else
        render :new
      end
    end
  
    def update
      if @content_unit.update(content_unit_params)
        redirect_to [@section, :content_units], notice: 'Content Unit was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @content_unit.destroy
      redirect_to [@section, :content_units], notice: 'ContentUnit deleted'
    end
  
    def set_section
      @section = Section.find(params[:section_id])
    end

    def set_content_unit
      @content_unit = ContentUnit.find(params[:id])
    end
  
    def content_unit_params
      params.fetch(:content_unit, {}).permit(:name, :content)
    end
  end
end
