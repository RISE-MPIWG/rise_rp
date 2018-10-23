module Api
  module V1
    module Resources
      class SectionsController < Api::ApiController
        before_action :set_resource, only: %i{index}

        require_power_check
        power crud: :resources, as: :resource_scope

        def index
          unless current_power.readable_resource?(@resource)
            render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
            return
          end
          if @resource.sections.empty?
            @resource.pull_sections(current_user)
          end
          @sections = @resource.sections
          @sections = @sections.where("sections.name ilike '%#{params[:filter]}%'") if params[:filter]
          paginate json: @sections
        end

        private

        def set_resource
          @resource = Resource.from_uuid(params[:resource_uuid])
        end
      end
    end
  end
end
