module Api
  module V1
    class SectionsController < Api::ApiController
      before_action :set_section, only: %i{show metadata}

      def show
        render json: @section
      end

      def metadata
        render json: @section.metadata.to_json
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
