RSpec.configure do |config|
  # FactoryBotのメソッドをテスト内で直接使えるようにする設定
  config.include FactoryBot::Syntax::Methods
end