module Api
  module V1
    class ContentUnitsController < Api::ApiController
      before_action :set_content_unit, only: %i{show metadata}

      def show
        render json: @content_unit
      end

      def metadata
        render json: @content_unit.cascading_metadata.to_json
      end

      private

      def render_errors
        render json: { errors: @content_unit.errors }, status: :unprocessable_entity
      end

      def set_content_unit
        @content_unit = ContentUnit.from_uuid(params[:uuid])
      end
    end
  end
end
