require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module YatsuRankingApp
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_paths << Rails.root.join('app', 'services')
    
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
