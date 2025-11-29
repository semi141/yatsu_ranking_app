require 'action_view' # ActionViewを最初にロードし、定数エラーを防止

# 互換性コードを直ちに実行
unless defined?(ActionView::Template::Handlers::ERB::ENCODING_FLAG)
  module ActionView
    module Template
      module Handlers
        module ERB
          ENCODING_FLAG = 'e'.freeze
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Home::Ranking", type: :request do
  # ----------------------------------------------------
  # テスト準備: FactoryBotでデータを準備
  # ----------------------------------------------------
  # データを分けるために、テストユーザーを2人作成します
  # let! で作成することで、テストが実行される前にデータがDBに存在する
  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user) }

  # 視聴データを準備（視聴数を明確にするため count を指定することが多いですが、ここでは単純な存在確認）
  # ユーザーAの視聴記録
  let!(:watch_a_1) { create(:watch, user: user_a, youtube_id: 'VIDEO_USER_A_1', count: 5) }
  # ユーザーBの視聴記録
  let!(:watch_b_1) { create(:watch, user: user_b, youtube_id: 'VIDEO_USER_B_1', count: 3) }

  # Deviseのヘルパーメソッドを使用するための設定
  include Devise::Test::IntegrationHelpers

  # ----------------------------------------------------
  # テストケース: 自分ランキング (マイページ) のデータ分離
  # ----------------------------------------------------
  describe "GET #ranking (自分ランキングの表示)" do
    
    before do
      # ユーザーAとしてログイン状態をシミュレート
      sign_in user_a
      
      # ランキングページにアクセスを試みる (パスは適宜修正してください)
      get ranking_path
    end

    it "ログインユーザーAのデータ（自分ランキング）のみがビューに表示されていること" do
      # データベースから取得したデータが正しくフィルタリングされ、HTMLに反映されているか検証する
      
      # ユーザーAの視聴動画ID ('VIDEO_USER_A_1') が含まれていることを検証
      expect(response.body).to include('VIDEO_USER_A_1') 
      
      # ユーザーBの視聴動画ID ('VIDEO_USER_B_1') が含まれていないことを検証
      # これが「ユーザーごとに別のデータが保存されている」ことを保証するテストです
      expect(response.body).not_to include('VIDEO_USER_B_1')
      
      # HTTPステータスコードが成功（200 OK）であることを検証
      expect(response).to have_http_status(:success)
    end
  end
end