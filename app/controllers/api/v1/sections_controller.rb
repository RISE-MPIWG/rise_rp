module Api
  module V1
    class SectionsController < Api::ApiController
      before_action :set_section, only: %i{show metadata}

      require_power_check
      power crud: :sections, as: :section_scope

      def show
        unless current_power.readable_resource?(@section.resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        render json: @section
      end

      def metadata
        unless current_power.readable_resource?(@section.resource)
          render json: { error: 'you do not have access to the resource this section belongs to' }, status: :unauthorized
          return
        end
        render json: @section.cascading_metadata.to_json
      end

      private

      def render_errors
        render json: { errors: @section.errors }, status: :unprocessable_entity
      end

      def set_section
        @section = Section.from_uuid(params[:uuid])
      end
    end
  end
end
