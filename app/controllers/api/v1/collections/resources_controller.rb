module Api
  module V1
    module Collections
      class ResourcesController < Api::ApiController
        before_action :set_collection, only: %i{index}

        require_power_check
        power crud: :resources, as: :resource_scope

        def index
          unless current_power.readable_collection?(@collection)
            render json: { error: 'you do not have access to this collection' }, status: :unauthorized
            return
          end
          @resources = @collection.resources
          @resources = @resources.where("resources.name ilike '%#{params[:filter]}%'") if params[:filter]
          paginate json: @resources, each_serializer: CollectionResourceSerializer
        end

        private

        def set_collection
          @collection = Collection.from_uuid(params[:collection_uuid])
        end
      end
    end
  end
end
