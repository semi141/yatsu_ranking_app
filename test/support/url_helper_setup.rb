class ActionDispatch::IntegrationTest
  # ActionController::UrlFor は、テストの実行に必要なため、ここで include します。
  include ActionController::UrlFor
  
  # その後、default_url_options を設定
  self.default_url_options = { host: 'localhost', port: 3000 }
end

# ★★★ モジュール名の一致を確認！ ★★★
# ActionDispatch::IntegrationTest にモジュールを適用
ActionDispatch::IntegrationTest.include IntegrationTestUrlSetup