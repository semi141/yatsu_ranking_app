require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module YatsuRankingApp
  class Application < Rails::Application
    config.load_defaults 7.2
    config.force_ssl = false
    config.session_store :cookie_store, key: '_yatsu_ranking_app_session'
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_lib(ignore: %w[assets tasks])
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
  end
end