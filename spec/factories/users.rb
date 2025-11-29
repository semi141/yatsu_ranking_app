FactoryBot.define do
  factory :user do
    # Deviseを使っている場合、メールアドレスとパスワードは必須です
    sequence(:email) { |n| "test_#{n}@example.com" } # テストごとにユニークなメールアドレスを生成
    password { "password" }
    password_confirmation { "password" }
    
    # 必要に応じて他の属性も追加（例: name, api_token など）
    api_token { SecureRandom.hex(20) } 
  end
end