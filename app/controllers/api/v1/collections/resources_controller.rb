module Api
  module V1
    module Collections
      class ResourcesController < Api::ApiController
        before_action :set_collection, only: %i{index}

        def index
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
