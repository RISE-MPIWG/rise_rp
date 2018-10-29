module Api
  module V1
    class ResourcesController < Api::ApiController
      before_action :set_resource, only: %i{show metadata}

      def search
        @q = params[:q]
        content_units = ContentUnit.search @q, highlight: false, includes: {section: {resource: :collection}}
        @results = []
        content_units.with_highlights.each do |cu, highlight|
          result = {}
          result[:section_id] = cu.section_id
          result[:resource_id] = cu.section.resource_id
          result[:collection_id] = cu.section.resource.collection_id
          result[:context] = cu.content
          @results << result
        end
        render json: @results.to_json
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
