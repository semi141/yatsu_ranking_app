require 'test_helper'

class RankingTest < ActionDispatch::IntegrationTest
  #self.default_url_options = { host: 'localhost', port: 3000 }
  #include Warden::Test::Helpers
  #include ActionController::UrlFor
  #self.use_fixtures = false
  #self.fixture_path = nil
  #self.fixture_paths = []
  self.use_transactional_tests = false
  #include ActionController::UrlFor
  #self.default_url_options = { host: 'localhost', port: 3000 }

  # データの準備
  def setup
  # 既存のデータを全て一旦クリーンアップ (念のため)
  Watch.delete_all
  Video.delete_all
  User.delete_all
  
  # --- ユーザー作成 ---
  # emailをユニークにするため、Create!を使用
  @user_a = User.create!(
      email: 'user_a@test.com', 
      password: 'password', 
      name: 'UserA', 
      api_token: SecureRandom.hex(16) 
  ) 
  @user_b = User.create!(email: 'user_b@test.com', password: 'password', name: 'UserB')
    
    # ゲストユーザーも一意なメールアドレスで作成する
    @guest_user = User.create!(email: "test_guest@test.com", password: SecureRandom.urlsafe_base64, guest: true)
    
    # --- 動画作成 ---
    @video_common = Video.create!(youtube_id: 'common_vid', title: 'Common Video', published_at: Time.zone.now)
    @video_a_only = Video.create!(youtube_id: 'a_only_vid', title: 'User A Only', published_at: Time.zone.now)
    
    # --- 視聴データ作成 ---
    # User A の視聴データ (共通動画 2回, A専用動画 1回)
    Watch.create!(user: @user_a, video: @video_common, watched_count: 2)
    Watch.create!(user: @user_a, video: @video_a_only, watched_count: 1)
    
    # User B の視聴データ (共通動画 3回)
    Watch.create!(user: @user_b, video: @video_common, watched_count: 3)
  end
  
  # テスト終了後のクリーンアップ
  def teardown
    Warden.test_reset!
    Watch.delete_all
    Video.delete_all
    User.delete_all
  end

  # --- テストケース 1: データ分離ロジック ---

  test "自分のランキングは他のユーザーの視聴データを含まないこと" do
    # ユーザーAとしてログイン
    sign_in @user_a

    # ランキングページにアクセス (タブは 'my' を指定)
    get root_url(tab: 'my')
    
    # 1. レスポンスが成功したことを確認
    assert_response :success

    # 2. 自分のランキング (@my_rankings) の総件数を検証
    assert_equal 2, assigns(:my_total_count), "ユーザーAのランキング総件数が間違っています。"

    # 3. ランキングのトップ動画の視聴回数を検証
    top_ranking = assigns(:my_rankings).first
    #puts "--- Debug Attributes ---"
    #puts top_ranking.attributes.inspect
    #puts "------------------------"
    
    assert_equal @video_common.id, top_ranking.id, "トップ動画が共通動画ではありません。"
    assert_equal 2, top_ranking['user_watches_count'], "ユーザーAの視聴回数が間違っています。"

    # 4. ランキングに User B のデータが混ざっていないことを確認
    assert_not_equal 3, top_ranking.user_watches_count, "User Bのデータが混入しています。"
  end

  # --- テストケース 2: ゲストユーザーの制限 ---

  test "ゲストユーザーは編集画面にアクセスできず、ルートにリダイレクトされること" do
    # ゲストユーザーとしてログイン
    sign_in @guest_user # setupで作成した @guest_user を使用
    
    # 編集画面のパスにアクセスを試みる
    get edit_user_registration_path
    
    # トップページにリダイレクトされることを検証
    assert_redirected_to root_path
    
    # 警告メッセージが表示されることを検証
    assert_equal "ゲストユーザーは情報の変更・アカウントの削除はできません。", flash[:alert]
  end

  test "ゲストユーザーは退会できず、ユーザー数が変化しないこと" do
    # ゲストユーザーとしてログイン
    sign_in @guest_user # setupで作成した @guest_user を使用
    
    # ユーザー数が変化しないこと（退会失敗）を検証
    assert_no_changes 'User.count' do
      # 退会処理を実行
      delete user_registration_path
    end
    
    # トップページにリダイレクトされることを検証
    assert_redirected_to root_path
    
    # 警告メッセージが表示されることを検証
    assert_equal "ゲストユーザーは情報の変更・アカウントの削除はできません。", flash[:alert]
  end
end