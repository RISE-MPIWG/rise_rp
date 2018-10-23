module Api
  module V1
    module Sections
      class ContentUnitsController < Api::ApiController
        before_action :set_section, only: %i{index docusky_index}

        require_power_check
        power crud: :resources, as: :resource_scope

        def index
          unless current_power.readable_resource?(@section.resource)
            render json: { error: 'you do not have access to the resource this section belongs to' }, status: :unauthorized
            return
          end
          @section.pull_content_units(current_user)
          @content_units = @section.content_units
          @content_units = @content_units.where("content_units.name ilike '%#{params[:filter]}%' or content ilike '%#{params[:filter]}%'") if params[:filter]
          paginate json: @content_units
        end

        private

        def set_section
          @section = Section.from_uuid(params[:section_uuid])
        end
      end
    end
  end
end
