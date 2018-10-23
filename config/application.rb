require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RiseRp
  class Application < Rails::Application
    # output the logs to docker
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = %i{subdomain uuid}
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    config.time_zone = 'Berlin'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.load_defaults 5.1
    config.encoding = "utf-8"
    config.generators.system_tests = nil

    config.generators do |g|
      g.template_engine :haml
    end
  end
end
