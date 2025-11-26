require 'rails_helper'

# テスト開始前に、必ずゲストユーザーを作成する
RSpec.configure do |config|
  config.before(:suite) do
    User.find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.guest = true
    end
  end
end

RSpec.describe "Users::Registrations", type: :request do
  # データベースにいるゲストユーザーを取得
  let(:guest_user) { User.find_by!(email: "guest@example.com") }
  
  # Deviseのヘルパーメソッド `sign_in` をテストで使うための設定
  include Devise::Test::IntegrationHelpers

  # ----------------------------------------------------
  # テストケース 1: 編集画面 (GET #edit) へのアクセス制限
  # ----------------------------------------------------
  describe "GET #edit" do
    before do
      # ゲストユーザーとしてログイン状態をシミュレート
      sign_in guest_user
    end

    it "ゲストユーザーは編集画面にアクセスできず、ルートにリダイレクトされること" do
      # 編集画面のパスにアクセスを試みる
      get edit_user_registration_path
      
      # トップページにリダイレクトされることを検証
      expect(response).to redirect_to(root_path)
      
      # 警告メッセージが表示されることを検証
      expect(flash[:alert]).to include("ゲストユーザーは情報の変更・アカウントの削除はできません。")
    end
  end

  # ----------------------------------------------------
  # テストケース 2: 退会処理 (DELETE #destroy) の実行制限
  # ----------------------------------------------------
  describe "DELETE #destroy" do
    before do
      # ゲストユーザーとしてログイン状態をシミュレート
      sign_in guest_user
    end

    it "ゲストユーザーは退会できず、ユーザー数が変化しないこと" do
      # ユーザー数が変化しないこと（退会失敗）を検証
      expect {
        # 退会処理を実行
        delete user_registration_path
      }.not_to change(User, :count) 
      
      # トップページにリダイレクトされることを検証
      expect(response).to redirect_to(root_path)
      
      # 警告メッセージが表示されることを検証
      expect(flash[:alert]).to include("ゲストユーザーは情報の変更・アカウントの削除はできません。")
    end
  end
end