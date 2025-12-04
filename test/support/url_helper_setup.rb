class ActionDispatch::IntegrationTest
  include ActionController::UrlFor
  
  # その後、default_url_options を設定
  self.default_url_options = { host: 'localhost', port: 3000 }
end
# ActionDispatch::IntegrationTest にモジュールを適用
ActionDispatch::IntegrationTest.include IntegrationTestUrlSetup