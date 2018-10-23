module Api
  module V1
    class CollectionsController < Api::ApiController
      before_action :set_collection, only: %i{show}
      def index
        paginate json: @collections
      end

      def show
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
