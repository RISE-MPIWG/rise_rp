module Api
  module V1
    module Sections
      class ContentUnitsController < Api::ApiController
        before_action :set_section, only: %i{index docusky_index}

        def index
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
