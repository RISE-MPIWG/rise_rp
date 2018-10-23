module Api
  module V1
    class ResourcesController < Api::ApiController
      before_action :set_resource, only: %i{show metadata}

      def index
        paginate json: @resources
      end

      def show
        render json: @resource
      end

      def metadata
        render json: @resource.metadata.to_json
      end

      private

      def render_errors
        render json: { errors: @resource.errors }, status: :unprocessable_entity
      end

      def set_resource
        @resource = Resource.from_uuid(params[:uuid])
      end
    end
  end
end
