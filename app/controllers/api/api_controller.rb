module Api
  class ApiController < ActionController::API
    include Consul::Controller
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActionController::MimeResponds
    include Logging

    respond_to :json

    # before_action :require_login!
    helper_method :user_signed_in?, :current_user

    def require_login!
      return true if authenticate_token

      render json: { errors: [{ detail: "Access denied" }] }, status: 401
    end

    current_power do
      Power.new(current_user)
    end

    before_action :set_locale

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

    def render_not_found_response(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def render_parameter_missing(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    def set_locale
      I18n.locale = if current_user && current_user.preferred_language.present?
                      current_user.preferred_language
                    elsif I18n.available_locales.include? extract_locale_from_accept_language_header
                      extract_locale_from_accept_language_header
                    else
                      'en'
                    end
    end

    private

    def current_user
      @_current_user ||= authenticate_token
    end

    def user_signed_in?
      current_user.present?
    end

    def authenticate_token
      if request.headers['RISE-API-TOKEN']
        token = request.headers['RISE-API-TOKEN']
        User.where(auth_token: token).where("token_created_at >= ?", 1.month.ago).first
      elsif request.headers['Cookie'] && !request.headers['Cookie'].empty?
        cookies_utils = RailsCompatibleCookiesUtils.new ENV['SECRET_KEY_BASE']
        value = cookies_utils.cookies(request.headers['Cookie'])['_rise_session']
        decrypted_value = cookies_utils.decrypt(value)
        User.where(id: decrypted_value["warden.user.user.key"].first.first.to_i).first if decrypted_value && decrypted_value["warden.user.user.key"]
      end
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE'].present?
    end
  end
end
