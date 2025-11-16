require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module YatsuRankingApp
  class Application < Rails::Application
    config.action_dispatch.cookies_same_site_protection = :none

    config.load_defaults 7.2

    config.autoload_paths << Rails.root.join('app', 'services')
    
    config.autoload_lib(ignore: %w[assets tasks])

    config.session_store :cookie_store, key: '_yatsu_ranking_app_session', secure: Rails.env.production?
  end
end