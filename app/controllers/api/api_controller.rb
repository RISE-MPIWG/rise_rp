module Api
  class ApiController < ActionController::API
    include ActionController::MimeResponds

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

    def render_not_found_response(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def render_parameter_missing(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end
  end
end
