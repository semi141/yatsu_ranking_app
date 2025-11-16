require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module YatsuRankingApp
  class Application < Rails::Application
    config.load_defaults 7.2

    # Cookie設定（最優先で上書き）
    config.action_dispatch.cookies_same_site_protection = :none
    config.force_ssl = false

    # セッション設定（secure: false 強制）
    config.session_store :cookie_store, 
                         key: '_yatsu_ranking_app_session', 
                         secure: false, 
                         same_site: :none

    # サービスパス
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_lib(ignore: %w[assets tasks])
  end
end