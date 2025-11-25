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
    require 'bootstrap_icons_rails'
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.paths << Gem.loaded_specs['bootstrap-icons-rails'].full_gem_path.join('assets', 'stylesheets')
  end
end