module Api
  module V1
    class CollectionsController < Api::ApiController
      # before_action :require_login!
      before_action :set_collection, only: %i{show}

      require_power_check
      power crud: :collections, as: :collection_scope

      def index
        @collections = current_power.readable_collections
        @collections = @collections.where("name ilike '%#{params[:filter]}%'") if params[:filter]
        paginate json: @collections
      end

      def show
        unless current_power.readable_collection?(@collection)
          render json: { error: 'you do not have access to this collection' }, status: :unauthorized
          return
        end
        render json: @collection
      end

      private

      def render_errors
        render json: { errors: @collection.errors }, status: :unprocessable_entity
      end

      def set_collection
        @collection = Collection.from_uuid(params[:uuid])
      end
    end
  end
end
