module Api
  module V1
    class ResourcesController < Api::ApiController
      before_action :set_resource, only: %i{show metadata}

      def search
        @q = params[:q]
        @content_units = ContentUnit.where("content ilike '%#{@q}%'").includes(:section, section: :resource, section: {resource: :collection})
        render json: @content_units, each_serializer: SearchResultContentUnitSerializer, q: @q
      end

      def index
        render json: @resources
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
