module Api
  module V1
    module Resources
      class SectionsController < Api::ApiController
        before_action :set_resource, only: %i{index}
        def index
          render json: @sections
        end

        private

        def set_resource
          @resource = Resource.from_uuid(params[:resource_uuid])
        end
      end
    end
  end
end
