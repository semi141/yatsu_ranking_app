# ゲストユーザーを特定するための定数
GUEST_USER_EMAIL = "guest@example.com"

# ゲストユーザーを作成（または見つける）
unless User.exists?(email: GUEST_USER_EMAIL)
  User.create!(
    name:                  "ゲストユーザー",
    email:                 GUEST_USER_EMAIL,
    password:              "password", # 任意だが、DBには必要
    password_confirmation: "password",
    guest:                 true
  )
  puts "ゲストユーザーを作成しました。"
end