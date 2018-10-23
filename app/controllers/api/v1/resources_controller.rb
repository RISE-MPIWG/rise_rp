module Api
  module V1
    class ResourcesController < Api::ApiController
      before_action :set_resource, only: %i{show metadata}

      require_power_check
      power crud: :resources, as: :resource_scope

      def index
        @resources = current_power.readable_resources
        @resources = @resources.where("resources.name ilike '%#{params[:filter]}%'") if params[:filter]
        paginate json: @resources
      end

      def show
        unless current_power.readable_resource?(@resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        render json: @resource
      end

      def metadata
        unless current_power.readable_resource?(@resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        render json: @resource.cascading_metadata.to_json
      end

      private

      def render_errors
        render json: { errors: @resource.errors }, status: :unprocessable_entity
      end

      def set_resource
        @resource = Resource.from_uuid(params[:uuid])
      end

      def resource_params
        params.require(:resource).permit(:filter)
      end
    end
  end
end
